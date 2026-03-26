import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';

import '../../features/atendimento/data/datasources/atendimento_local_datasource.dart';
import '../../features/atendimento/data/models/atendimento_model.dart';
import '../../features/auth/data/datasources/usuario_local_datasource.dart';
import '../../features/auth/data/models/usuario_model.dart';
import '../../features/base/data/datasources/base_local_datasource.dart';
import '../../features/base/data/models/base_model.dart';
import '../../features/cliente/data/datasources/cliente_local_datasource.dart';
import '../../features/cliente/data/models/cliente_model.dart';
import '../constants/app_constants.dart';
import '../database/app_database.dart';
import '../network/network_info.dart';
import 'sync_cursor_datasource.dart';
import 'sync_queue_datasource.dart';

/// Status geral da sincronização.
enum SyncStatus {
  /// Fila vazia — tudo sincronizado.
  sincronizado,

  /// Itens aguardando envio.
  pendente,

  /// Itens que atingiram o máximo de tentativas.
  erro,

  /// Sync em execução agora.
  sincronizando,
}

/// Orquestra a fila de sincronização com backoff exponencial.
///
/// RN-034: Quando a conexão é detectada, a fila é processada em ordem cronológica.
/// RN-035: Falha → mantém na fila com backoff exponencial (1s, 2s, 4s, ... max 60s).
/// RN-036: Conflitos resolvidos com last-write-wins via updatedAt.
class SyncManager {
  SyncManager({
    required this.syncQueue,
    required this.networkInfo,
    required this.dio,
    required this.clienteLocalDatasource,
    required this.baseLocalDatasource,
    required this.atendimentoLocalDatasource,
    required this.usuarioLocalDatasource,
    required this.syncCursorDatasource,
  });

  final SyncQueueDatasource syncQueue;
  final NetworkInfo networkInfo;
  final Dio dio;
  final ClienteLocalDatasource clienteLocalDatasource;
  final BaseLocalDatasource baseLocalDatasource;
  final AtendimentoLocalDatasource atendimentoLocalDatasource;
  final UsuarioLocalDatasource usuarioLocalDatasource;
  final SyncCursorDatasource syncCursorDatasource;

  static final DateTime _cursorInicial =
      DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

  StreamSubscription<bool>? _connectivitySubscription;
  bool _isProcessing = false;

  final _statusController = StreamController<SyncStatus>.broadcast();

  /// Stream de status para o SyncStatusWidget.
  Stream<SyncStatus> get statusStream => _statusController.stream;

  /// Inicia o monitoramento de conectividade (RN-032, S6-03).
  void iniciarMonitoramento() {
    _connectivitySubscription =
        networkInfo.onConnectivityChanged.listen((connected) {
      if (connected) {
        processar();
      }
    });
  }

  /// Para o monitoramento.
  Future<void> dispose() async {
    await _connectivitySubscription?.cancel();
    await _statusController.close();
  }

  /// Obtém o status atual da fila.
  Future<SyncStatus> obterStatus() async {
    if (_isProcessing) return SyncStatus.sincronizando;

    final totalPendentes = await syncQueue.contarPendentes();
    if (totalPendentes == 0) return SyncStatus.sincronizado;

    final comErro = await syncQueue.contarComErro(maxRetries: syncMaxRetries);
    if (comErro > 0 && comErro == totalPendentes) return SyncStatus.erro;

    return SyncStatus.pendente;
  }

  /// Resumo detalhado da fila para a tela de sincronização.
  Future<Map<String, dynamic>> obterResumo() async {
    final todos = await syncQueue.obterTodos();
    final pendentes = todos.where((i) => i.tentativas < syncMaxRetries).length;
    final comErro = todos.where((i) => i.tentativas >= syncMaxRetries).length;
    final ultimoPull = await syncCursorDatasource.obterUltimoPull();

    // Contagem por entidade
    final porEntidade = <String, int>{};
    for (final item in todos) {
      porEntidade[item.entidade] = (porEntidade[item.entidade] ?? 0) + 1;
    }

    return {
      'total': todos.length,
      'pendentes': pendentes,
      'comErro': comErro,
      'porEntidade': porEntidade,
      'ultimoPull': ultimoPull,
      'isProcessing': _isProcessing,
    };
  }

  /// Processa a fila de sincronização.
  ///
  /// Retorna o número de itens sincronizados com sucesso.
  Future<int> processar() async {
    if (_isProcessing) return 0;

    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return 0;

    _isProcessing = true;
    _statusController.add(SyncStatus.sincronizando);

    int sincronizados = 0;

    try {
      final itens = await syncQueue.obterPendentes(
        maxRetries: syncMaxRetries,
      );

      final processedIds = <String>{};

      for (var index = 0; index < itens.length; index++) {
        final item = itens[index];
        if (processedIds.contains(item.id)) {
          continue;
        }

        if (_isPontoRastreamentoCreate(item)) {
          final batch = <SyncQueueEntry>[item];
          processedIds.add(item.id);

          for (var nextIndex = index + 1;
              nextIndex < itens.length;
              nextIndex++) {
            final nextItem = itens[nextIndex];
            if (!_isPontoRastreamentoCreate(nextItem) ||
                processedIds.contains(nextItem.id)) {
              break;
            }
            batch.add(nextItem);
            processedIds.add(nextItem.id);
          }

          try {
            await _enviarPontosRastreamentoBatch(batch);
            for (final batchItem in batch) {
              await syncQueue.remover(batchItem.id);
            }
            sincronizados += batch.length;
          } catch (_) {
            for (final batchItem in batch) {
              final backoff = _calcularBackoff(batchItem.tentativas);
              await syncQueue.incrementarTentativas(
                batchItem.id,
                backoff: backoff,
              );
            }
          }
          continue;
        }

        try {
          await _enviar(item);
          await syncQueue.remover(item.id);
          sincronizados++;
        } catch (_) {
          final backoff = _calcularBackoff(item.tentativas);
          await syncQueue.incrementarTentativas(item.id, backoff: backoff);
        }
      }

      try {
        await _sincronizarPull();
      } catch (_) {
        // Pull sync não deve descartar pushes já concluídos.
      }
    } finally {
      _isProcessing = false;
      final status = await obterStatus();
      _statusController.add(status);
    }

    return sincronizados;
  }

  bool _isPontoRastreamentoCreate(SyncQueueEntry item) =>
      item.entidade == 'ponto_rastreamento' && item.operacao == 'create';

  /// RN-035: backoff exponencial — 1s, 2s, 4s, 8s, 16s, max 60s.
  Duration _calcularBackoff(int tentativasAtuais) {
    final seconds =
        syncInitialBackoff.inSeconds * pow(2, tentativasAtuais).toInt();
    final clampedSeconds = min(seconds, syncMaxBackoff.inSeconds);
    return Duration(seconds: clampedSeconds);
  }

  /// Despacha o item para a API correta baseado na entidade/operação.
  Future<void> _enviar(SyncQueueEntry item) async {
    final payload = jsonDecode(item.payload) as Map<String, dynamic>;

    switch (item.entidade) {
      case 'cliente':
        await _enviarCliente(item.operacao, payload);
      case 'atendimento':
        await _enviarAtendimento(item.operacao, payload);
      case 'ponto_rastreamento':
        await _enviarPontoRastreamento(item.operacao, payload);
      case 'base':
        await _enviarBase(item.operacao, payload);
      default:
        throw UnsupportedError('Entidade desconhecida: ${item.entidade}');
    }
  }

  Future<void> _enviarCliente(
      String operacao, Map<String, dynamic> payload) async {
    switch (operacao) {
      case 'create':
        await dio.post('/clientes', data: payload);
      case 'update':
        // RN-036: servidor usa updated_at para last-write-wins
        await dio.put('/clientes/${payload['id']}', data: payload);
      default:
        throw UnsupportedError('Operação desconhecida para cliente: $operacao');
    }
  }

  Future<void> _enviarAtendimento(
      String operacao, Map<String, dynamic> payload) async {
    switch (operacao) {
      case 'create':
        await dio.post('/atendimentos', data: payload);
      case 'update':
        await dio.put('/atendimentos/${payload['id']}', data: payload);
      case 'status_update':
        final atendimentoId = payload['id'] as String;
        await dio.patch(
          '/atendimentos/$atendimentoId/status',
          data: {
            'novoStatus': payload['novoStatus'],
            'atualizadoEm': payload['atualizadoEm'],
            'distanciaRealKm': payload['distanciaRealKm'],
            'valorCobrado': payload['valorCobrado'],
          },
        );
      default:
        throw UnsupportedError(
            'Operação desconhecida para atendimento: $operacao');
    }
  }

  /// S6-05: Pontos de rastreamento são enviados individualmente na fila,
  /// mas a API aceita batch. O SyncManager agrupa por atendimentoId.
  Future<void> _enviarPontoRastreamento(
      String operacao, Map<String, dynamic> payload) async {
    if (operacao == 'create') {
      await dio.post(
        '/rastreamento/pontos',
        data: {
          'pontos': [_normalizarPontoRastreamentoPayload(payload)],
        },
      );
    } else {
      throw UnsupportedError(
          'Operação desconhecida para ponto_rastreamento: $operacao');
    }
  }

  Future<void> _enviarPontosRastreamentoBatch(
    List<SyncQueueEntry> itens,
  ) async {
    final pontos = itens
        .map((item) => jsonDecode(item.payload) as Map<String, dynamic>)
        .map(_normalizarPontoRastreamentoPayload)
        .toList();

    await dio.post(
      '/rastreamento/pontos',
      data: {'pontos': pontos},
    );
  }

  Map<String, dynamic> _normalizarPontoRastreamentoPayload(
    Map<String, dynamic> payload,
  ) {
    return {
      'id': payload['id'],
      'atendimentoId': payload['atendimentoId'] ?? payload['atendimento_id'],
      'latitude': payload['latitude'],
      'longitude': payload['longitude'],
      'accuracy': payload['accuracy'],
      'velocidade': payload['velocidade'],
      'timestamp': payload['timestamp'],
    };
  }

  Future<void> _enviarBase(
      String operacao, Map<String, dynamic> payload) async {
    switch (operacao) {
      case 'create':
        await dio.post('/bases', data: payload);
      case 'update':
        await dio.put('/bases/${payload['id']}', data: payload);
      default:
        throw UnsupportedError('Operação desconhecida para base: $operacao');
    }
  }

  Future<void> _sincronizarPull() async {
    final desde =
        await syncCursorDatasource.obterUltimoPull() ?? _cursorInicial;
    final response = await dio.get(
      '/sync/pull',
      queryParameters: {'desde': desde.toUtc().toIso8601String()},
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw StateError('Resposta inválida de /sync/pull');
    }

    final idsPendentes = await _obterIdsPendentesPorEntidade();

    await _aplicarUsuarios(
        data['usuarios'], idsPendentes['usuario'] ?? const {});
    await _aplicarClientes(
        data['clientes'], idsPendentes['cliente'] ?? const {});
    await _aplicarBases(data['bases'], idsPendentes['base'] ?? const {});
    await _aplicarAtendimentos(
      data['atendimentos'],
      idsPendentes['atendimento'] ?? const {},
    );

    final sincronizadoEm = data['sincronizadoEm'] as String?;
    if (sincronizadoEm != null && sincronizadoEm.isNotEmpty) {
      final parsed = DateTime.tryParse(sincronizadoEm);
      if (parsed != null) {
        await syncCursorDatasource.salvarUltimoPull(parsed);
      }
    }
  }

  Future<Map<String, Set<String>>> _obterIdsPendentesPorEntidade() async {
    final itens = await syncQueue.obterTodos();
    final ids = <String, Set<String>>{};

    for (final item in itens) {
      final payload = jsonDecode(item.payload);
      if (payload is! Map<String, dynamic>) {
        continue;
      }
      final id = payload['id'];
      if (id is! String || id.isEmpty) {
        continue;
      }
      ids.putIfAbsent(item.entidade, () => <String>{}).add(id);
    }

    return ids;
  }

  Future<void> _aplicarUsuarios(dynamic raw, Set<String> idsPendentes) async {
    for (final json in _asMapList(raw)) {
      final model = UsuarioModel.fromJson(json);
      if (idsPendentes.contains(model.id)) {
        continue;
      }
      final existente = await usuarioLocalDatasource.obterPorId(model.id);
      if (existente == null) {
        await usuarioLocalDatasource.inserir(model);
      } else {
        await usuarioLocalDatasource.atualizar(model);
      }
    }
  }

  Future<void> _aplicarClientes(dynamic raw, Set<String> idsPendentes) async {
    for (final json in _asMapList(raw)) {
      final model = ClienteModel.fromJson(json);
      if (idsPendentes.contains(model.id)) {
        continue;
      }
      final existente = await clienteLocalDatasource.obterPorId(model.id);
      if (existente == null) {
        await clienteLocalDatasource.inserir(model);
      } else {
        await clienteLocalDatasource.atualizar(model);
      }
    }
  }

  Future<void> _aplicarBases(dynamic raw, Set<String> idsPendentes) async {
    for (final json in _asMapList(raw)) {
      final model = BaseModel.fromJson(json);
      if (idsPendentes.contains(model.id)) {
        continue;
      }
      final existente = await baseLocalDatasource.obterPorId(model.id);
      if (existente == null) {
        await baseLocalDatasource.inserir(model);
      } else {
        await baseLocalDatasource.atualizar(model);
      }
    }
  }

  Future<void> _aplicarAtendimentos(
    dynamic raw,
    Set<String> idsPendentes,
  ) async {
    for (final json in _asMapList(raw)) {
      final model = AtendimentoModel.fromJson(json);
      if (idsPendentes.contains(model.id)) {
        continue;
      }
      final existente = await atendimentoLocalDatasource.obterPorId(model.id);
      if (existente == null) {
        await atendimentoLocalDatasource.inserir(model);
      } else {
        await atendimentoLocalDatasource.atualizar(model);
      }
    }
  }

  List<Map<String, dynamic>> _asMapList(dynamic raw) {
    if (raw is! List) {
      return const [];
    }

    return raw.whereType<Map<String, dynamic>>().toList();
  }
}

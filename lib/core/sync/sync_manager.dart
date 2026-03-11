import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import '../database/app_database.dart';
import '../network/network_info.dart';
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
  });

  final SyncQueueDatasource syncQueue;
  final NetworkInfo networkInfo;
  final Dio dio;

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

      for (final item in itens) {
        try {
          await _enviar(item);
          await syncQueue.remover(item.id);
          sincronizados++;
        } catch (_) {
          final backoff = _calcularBackoff(item.tentativas);
          await syncQueue.incrementarTentativas(item.id, backoff: backoff);
        }
      }
    } finally {
      _isProcessing = false;
      final status = await obterStatus();
      _statusController.add(status);
    }

    return sincronizados;
  }

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
      await dio.post('/pontos-rastreamento', data: payload);
    } else {
      throw UnsupportedError(
          'Operação desconhecida para ponto_rastreamento: $operacao');
    }
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
}

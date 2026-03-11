import '../../../../core/sync/sync_queue_datasource.dart';
import '../../domain/entities/ponto_rastreamento.dart';
import '../../domain/repositories/rastreamento_repository.dart';
import '../datasources/rastreamento_local_datasource.dart';
import '../models/ponto_rastreamento_model.dart';

/// Offline-first: salva localmente e enfileira para sync.
class RastreamentoRepositoryImpl implements RastreamentoRepository {
  RastreamentoRepositoryImpl({
    required this.localDatasource,
    required this.syncQueue,
  });

  final RastreamentoLocalDatasource localDatasource;
  final SyncQueueDatasource syncQueue;

  @override
  Future<void> salvarPonto(PontoRastreamento ponto) async {
    final model = PontoRastreamentoModel.fromEntity(ponto);
    await localDatasource.inserir(model);
    await syncQueue.adicionar(
      entidade: 'ponto_rastreamento',
      operacao: 'create',
      payload: model.toJson(),
    );
  }

  @override
  Future<List<PontoRastreamento>> obterPontosPorAtendimento(
      String atendimentoId) async {
    final models = await localDatasource.listarPorAtendimento(atendimentoId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> marcarComoSincronizados(List<String> ids) async {
    await localDatasource.marcarComoSincronizados(ids);
  }

  @override
  Future<List<PontoRastreamento>> obterNaoSincronizados() async {
    final models = await localDatasource.listarNaoSincronizados();
    return models.map((m) => m.toEntity()).toList();
  }
}

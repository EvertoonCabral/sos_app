import '../../../../core/sync/sync_queue_datasource.dart';
import '../../domain/entities/atendimento.dart';
import '../../domain/entities/atendimento_enums.dart';
import '../../domain/repositories/atendimento_repository.dart';
import '../datasources/atendimento_local_datasource.dart';
import '../models/atendimento_model.dart';

/// Offline-first: lê/escreve do local, adiciona à sync queue.
class AtendimentoRepositoryImpl implements AtendimentoRepository {
  AtendimentoRepositoryImpl({
    required this.localDatasource,
    required this.syncQueue,
  });

  final AtendimentoLocalDatasource localDatasource;
  final SyncQueueDatasource syncQueue;

  @override
  Future<Atendimento> criar(Atendimento atendimento) async {
    final model = AtendimentoModel.fromEntity(atendimento);
    await localDatasource.inserir(model);
    await syncQueue.adicionar(
      entidade: 'atendimento',
      operacao: 'create',
      payload: model.toJson(),
    );
    return atendimento;
  }

  @override
  Future<List<Atendimento>> listar({AtendimentoStatus? status}) async {
    final models = status != null
        ? await localDatasource.listarPorStatus(status.name)
        : await localDatasource.listarTodos();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Atendimento> obterPorId(String id) async {
    final model = await localDatasource.obterPorId(id);
    return model!.toEntity();
  }

  @override
  Future<Atendimento> atualizar(Atendimento atendimento) async {
    final model = AtendimentoModel.fromEntity(atendimento);
    await localDatasource.atualizar(model);
    await syncQueue.adicionar(
      entidade: 'atendimento',
      operacao: 'update',
      payload: model.toJson(),
    );
    return atendimento;
  }

  @override
  Future<Atendimento> atualizarStatus(Atendimento atendimento) async {
    final model = AtendimentoModel.fromEntity(atendimento);
    await localDatasource.atualizar(model);
    await syncQueue.adicionar(
      entidade: 'atendimento',
      operacao: 'status_update',
      payload: {
        'id': atendimento.id,
        'novoStatus': atendimento.status.toApiValue(),
        'atualizadoEm': atendimento.atualizadoEm.toIso8601String(),
        'distanciaRealKm': atendimento.distanciaRealKm,
        'valorCobrado': atendimento.valorCobrado,
      },
    );
    return atendimento;
  }
}

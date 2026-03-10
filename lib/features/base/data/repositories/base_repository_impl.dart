import '../../../../core/sync/sync_queue_datasource.dart';
import '../../domain/entities/base.dart';
import '../../domain/repositories/base_repository.dart';
import '../datasources/base_local_datasource.dart';
import '../models/base_model.dart';

/// Offline-first: lê/escreve do local, adiciona à sync queue.
class BaseRepositoryImpl implements BaseRepository {
  BaseRepositoryImpl({
    required this.localDatasource,
    required this.syncQueue,
  });

  final BaseLocalDatasource localDatasource;
  final SyncQueueDatasource syncQueue;

  @override
  Future<Base> criar(Base base) async {
    final model = BaseModel.fromEntity(base);
    await localDatasource.inserir(model);
    await syncQueue.adicionar(
      entidade: 'base',
      operacao: 'create',
      payload: model.toJson(),
    );
    return base;
  }

  @override
  Future<List<Base>> listarTodas() async {
    final models = await localDatasource.listarTodas();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Base> definirPrincipal(String baseId) async {
    await localDatasource.definirPrincipal(baseId);
    await syncQueue.adicionar(
      entidade: 'base',
      operacao: 'set_principal',
      payload: {'id': baseId},
    );
    final model = await localDatasource.obterPorId(baseId);
    return model!.toEntity();
  }
}

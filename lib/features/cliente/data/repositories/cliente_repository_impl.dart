import '../../../../core/sync/sync_queue_datasource.dart';
import '../../domain/entities/cliente.dart';
import '../../domain/repositories/cliente_repository.dart';
import '../datasources/cliente_local_datasource.dart';
import '../models/cliente_model.dart';

/// Implementação offline-first: sempre lê/escreve do local,
/// adiciona à sync queue para enviar ao backend.
class ClienteRepositoryImpl implements ClienteRepository {
  ClienteRepositoryImpl({
    required this.localDatasource,
    required this.syncQueue,
  });

  final ClienteLocalDatasource localDatasource;
  final SyncQueueDatasource syncQueue;

  @override
  Future<Cliente> criar(Cliente cliente) async {
    final model = ClienteModel.fromEntity(cliente);
    await localDatasource.inserir(model);
    await syncQueue.adicionar(
      entidade: 'cliente',
      operacao: 'create',
      payload: model.toJson(),
    );
    return cliente;
  }

  @override
  Future<Cliente> atualizar(Cliente cliente) async {
    final model = ClienteModel.fromEntity(cliente);
    await localDatasource.atualizar(model);
    await syncQueue.adicionar(
      entidade: 'cliente',
      operacao: 'update',
      payload: model.toJson(),
    );
    return cliente;
  }

  @override
  Future<List<Cliente>> buscar(String query) async {
    final models = await localDatasource.buscar(query);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Cliente?> obterPorId(String id) async {
    final model = await localDatasource.obterPorId(id);
    return model?.toEntity();
  }

  @override
  Future<List<Cliente>> listarTodos() async {
    final models = await localDatasource.listarTodos();
    return models.map((m) => m.toEntity()).toList();
  }
}

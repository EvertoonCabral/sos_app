import 'package:injectable/injectable.dart';

import '../../../features/cliente/data/datasources/cliente_local_datasource.dart';
import '../../../features/cliente/data/repositories/cliente_repository_impl.dart';
import '../../../features/cliente/domain/repositories/cliente_repository.dart';
import '../../../features/cliente/domain/usecases/atualizar_cliente.dart';
import '../../../features/cliente/domain/usecases/buscar_clientes.dart';
import '../../../features/cliente/domain/usecases/criar_cliente.dart';
import '../../database/app_database.dart';
import '../../sync/sync_queue_datasource.dart';

@module
abstract class ClienteModule {
  @lazySingleton
  ClienteLocalDatasource clienteLocalDatasource(AppDatabase db) =>
      ClienteLocalDatasourceImpl(db);

  @lazySingleton
  ClienteRepository clienteRepository(
    ClienteLocalDatasource localDatasource,
    SyncQueueDatasource syncQueue,
  ) =>
      ClienteRepositoryImpl(
        localDatasource: localDatasource,
        syncQueue: syncQueue,
      );

  @lazySingleton
  CriarCliente criarCliente(ClienteRepository repository) =>
      CriarCliente(repository);

  @lazySingleton
  BuscarClientes buscarClientes(ClienteRepository repository) =>
      BuscarClientes(repository);

  @lazySingleton
  AtualizarCliente atualizarCliente(ClienteRepository repository) =>
      AtualizarCliente(repository);
}

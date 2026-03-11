import 'package:injectable/injectable.dart';

import '../../../features/base/data/datasources/base_local_datasource.dart';
import '../../../features/base/data/repositories/base_repository_impl.dart';
import '../../../features/base/domain/repositories/base_repository.dart';
import '../../../features/base/domain/usecases/criar_base.dart';
import '../../../features/base/domain/usecases/definir_base_principal.dart';
import '../../../features/base/domain/usecases/listar_bases.dart';
import '../../database/app_database.dart';
import '../../sync/sync_queue_datasource.dart';

@module
abstract class BaseModule {
  @lazySingleton
  BaseLocalDatasource baseLocalDatasource(AppDatabase db) =>
      BaseLocalDatasourceImpl(db);

  @lazySingleton
  BaseRepository baseRepository(
    BaseLocalDatasource localDatasource,
    SyncQueueDatasource syncQueue,
  ) =>
      BaseRepositoryImpl(
        localDatasource: localDatasource,
        syncQueue: syncQueue,
      );

  @lazySingleton
  CriarBase criarBase(BaseRepository repository) => CriarBase(repository);

  @lazySingleton
  ListarBases listarBases(BaseRepository repository) =>
      ListarBases(repository);

  @lazySingleton
  DefinirBasePrincipal definirBasePrincipal(BaseRepository repository) =>
      DefinirBasePrincipal(repository);
}

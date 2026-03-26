import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../database/app_database.dart';
import '../../geo/geo_service.dart';
import '../../geo/geo_service_impl.dart';
import '../../network/network_info.dart';
import '../../../features/atendimento/data/datasources/atendimento_local_datasource.dart';
import '../../../features/auth/data/datasources/usuario_local_datasource.dart';
import '../../../features/base/data/datasources/base_local_datasource.dart';
import '../../../features/cliente/data/datasources/cliente_local_datasource.dart';
import '../../sync/sync_manager.dart';
import '../../sync/sync_cursor_datasource.dart';
import '../../sync/sync_queue_datasource.dart';
import '../../utils/distance_calculator.dart';

@module
abstract class CoreModule {
  @lazySingleton
  SyncQueueDatasource syncQueueDatasource(AppDatabase db) =>
      SyncQueueDatasource(db);

  @lazySingleton
  SyncManager syncManager(
    SyncQueueDatasource syncQueue,
    NetworkInfo networkInfo,
    Dio dio,
    ClienteLocalDatasource clienteLocalDatasource,
    BaseLocalDatasource baseLocalDatasource,
    AtendimentoLocalDatasource atendimentoLocalDatasource,
    UsuarioLocalDatasource usuarioLocalDatasource,
    FlutterSecureStorage secureStorage,
  ) =>
      SyncManager(
        syncQueue: syncQueue,
        networkInfo: networkInfo,
        dio: dio,
        clienteLocalDatasource: clienteLocalDatasource,
        baseLocalDatasource: baseLocalDatasource,
        atendimentoLocalDatasource: atendimentoLocalDatasource,
        usuarioLocalDatasource: usuarioLocalDatasource,
        syncCursorDatasource: SyncCursorDatasource(secureStorage),
      );

  @lazySingleton
  DistanceCalculator get distanceCalculator => DistanceCalculator();

  @lazySingleton
  GeoService geoService(Dio dio) => GeoServiceImpl(dio);
}

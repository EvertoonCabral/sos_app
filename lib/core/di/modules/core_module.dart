import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../database/app_database.dart';
import '../../geo/geo_service.dart';
import '../../geo/geo_service_impl.dart';
import '../../network/network_info.dart';
import '../../sync/sync_manager.dart';
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
  ) =>
      SyncManager(syncQueue: syncQueue, networkInfo: networkInfo, dio: dio);

  @lazySingleton
  DistanceCalculator get distanceCalculator => DistanceCalculator();

  @lazySingleton
  GeoService get geoService => GeoServiceImpl();
}

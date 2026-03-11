import 'package:injectable/injectable.dart';

import '../../database/app_database.dart';
import '../../geo/geo_service.dart';
import '../../geo/geo_service_impl.dart';
import '../../sync/sync_queue_datasource.dart';
import '../../utils/distance_calculator.dart';

@module
abstract class CoreModule {
  @lazySingleton
  SyncQueueDatasource syncQueueDatasource(AppDatabase db) =>
      SyncQueueDatasource(db);

  @lazySingleton
  DistanceCalculator get distanceCalculator => DistanceCalculator();

  @lazySingleton
  GeoService get geoService => GeoServiceImpl();
}

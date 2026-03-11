import 'package:injectable/injectable.dart';

import '../../../features/rastreamento/data/datasources/rastreamento_local_datasource.dart';
import '../../../features/rastreamento/data/repositories/rastreamento_repository_impl.dart';
import '../../../features/rastreamento/domain/repositories/rastreamento_repository.dart';
import '../../../features/rastreamento/domain/usecases/calcular_valor_real.dart';
import '../../../features/rastreamento/domain/usecases/obter_percurso.dart';
import '../../../features/rastreamento/domain/usecases/registrar_ponto.dart';
import '../../database/app_database.dart';
import '../../geo/gps_collector.dart';
import '../../sync/sync_queue_datasource.dart';
import '../../utils/distance_calculator.dart';

@module
abstract class RastreamentoModule {
  @lazySingleton
  RastreamentoLocalDatasource rastreamentoLocalDatasource(AppDatabase db) =>
      RastreamentoLocalDatasourceImpl(db);

  @lazySingleton
  RastreamentoRepository rastreamentoRepository(
    RastreamentoLocalDatasource localDatasource,
    SyncQueueDatasource syncQueue,
  ) =>
      RastreamentoRepositoryImpl(
        localDatasource: localDatasource,
        syncQueue: syncQueue,
      );

  @lazySingleton
  RegistrarPonto registrarPonto(RastreamentoRepository repository) =>
      RegistrarPonto(repository);

  @lazySingleton
  ObterPercurso obterPercurso(RastreamentoRepository repository) =>
      ObterPercurso(repository);

  @lazySingleton
  CalcularValorReal calcularValorReal(
    RastreamentoRepository repository,
    DistanceCalculator calculator,
  ) =>
      CalcularValorReal(repository, calculator);

  @lazySingleton
  GpsCollector gpsCollector() => GpsCollector();
}

import 'package:injectable/injectable.dart';

import '../../../features/dashboard/data/datasources/dashboard_local_datasource.dart';
import '../../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../../features/dashboard/domain/usecases/obter_km_por_cliente.dart';
import '../../../features/dashboard/domain/usecases/obter_resumo_periodo.dart';
import '../../../features/dashboard/domain/usecases/obter_tempo_por_etapa.dart';
import '../../database/app_database.dart';

@module
abstract class DashboardModule {
  @lazySingleton
  DashboardLocalDatasource dashboardLocalDatasource(AppDatabase db) =>
      DashboardLocalDatasourceImpl(db);

  @lazySingleton
  DashboardRepository dashboardRepository(
    DashboardLocalDatasource localDatasource,
  ) =>
      DashboardRepositoryImpl(localDatasource: localDatasource);

  @lazySingleton
  ObterResumoPeriodo obterResumoPeriodo(DashboardRepository repository) =>
      ObterResumoPeriodo(repository);

  @lazySingleton
  ObterKmPorCliente obterKmPorCliente(DashboardRepository repository) =>
      ObterKmPorCliente(repository);

  @lazySingleton
  ObterTempoPorEtapa obterTempoPorEtapa(DashboardRepository repository) =>
      ObterTempoPorEtapa(repository);
}

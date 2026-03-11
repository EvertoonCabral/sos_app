import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/database/app_database.dart';
import 'package:sos_app/core/network/network_info.dart';
import 'package:sos_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:sos_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:sos_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:sos_app/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:sos_app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:sos_app/features/dashboard/domain/usecases/obter_km_por_cliente.dart';
import 'package:sos_app/features/dashboard/domain/usecases/obter_resumo_periodo.dart';
import 'package:sos_app/features/dashboard/domain/usecases/obter_tempo_por_etapa.dart';
import 'package:sos_app/features/rastreamento/data/datasources/rastreamento_local_datasource.dart';
import 'package:sos_app/features/rastreamento/domain/repositories/rastreamento_repository.dart';
import 'package:sos_app/features/rastreamento/domain/usecases/calcular_valor_real.dart';
import 'package:sos_app/features/rastreamento/domain/usecases/obter_percurso.dart';
import 'package:sos_app/features/rastreamento/domain/usecases/registrar_ponto.dart';

// --- Core Mocks ---
class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockDio extends Mock implements Dio {}

class MockAppDatabase extends Mock implements AppDatabase {}

class MockConnectivity extends Mock implements Connectivity {}

// --- Auth Mocks ---
class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

class MockAuthLocalDatasource extends Mock implements AuthLocalDatasource {}

// --- Rastreamento Mocks ---
class MockRastreamentoRepository extends Mock
    implements RastreamentoRepository {}

class MockRastreamentoLocalDatasource extends Mock
    implements RastreamentoLocalDatasource {}

class MockRegistrarPonto extends Mock implements RegistrarPonto {}

class MockObterPercurso extends Mock implements ObterPercurso {}

class MockCalcularValorReal extends Mock implements CalcularValorReal {}

// --- Dashboard Mocks ---
class MockDashboardRepository extends Mock implements DashboardRepository {}

class MockDashboardLocalDatasource extends Mock
    implements DashboardLocalDatasource {}

class MockObterResumoPeriodo extends Mock implements ObterResumoPeriodo {}

class MockObterKmPorCliente extends Mock implements ObterKmPorCliente {}

class MockObterTempoPorEtapa extends Mock implements ObterTempoPorEtapa {}

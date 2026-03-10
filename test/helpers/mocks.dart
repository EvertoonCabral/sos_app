import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/database/app_database.dart';
import 'package:sos_app/core/network/network_info.dart';
import 'package:sos_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:sos_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:sos_app/features/auth/domain/repositories/auth_repository.dart';

// --- Core Mocks ---
class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockDio extends Mock implements Dio {}

class MockAppDatabase extends Mock implements AppDatabase {}

class MockConnectivity extends Mock implements Connectivity {}

// --- Auth Mocks ---
class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

class MockAuthLocalDatasource extends Mock implements AuthLocalDatasource {}

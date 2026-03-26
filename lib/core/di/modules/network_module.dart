import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../network/http_client.dart';
import '../../network/network_info.dart';

@module
abstract class NetworkModule {
  @singleton
  Dio dio(
    FlutterSecureStorage secureStorage,
    NetworkInfo networkInfo,
  ) =>
      configureDio(
        dio: Dio(),
        secureStorage: secureStorage,
        networkInfo: networkInfo,
      );

  @singleton
  Connectivity get connectivity => Connectivity();

  @singleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();
}

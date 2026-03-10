import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkModule {
  @singleton
  Dio get dio => Dio();

  @singleton
  Connectivity get connectivity => Connectivity();

  @singleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();
}

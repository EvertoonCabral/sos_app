import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/app_config.dart';
import '../constants/app_constants.dart';
import 'network_info.dart';

Dio configureDio({
  required Dio dio,
  required FlutterSecureStorage secureStorage,
  required NetworkInfo networkInfo,
}) {
  dio.options = BaseOptions(
    baseUrl: AppConfig.instance.apiBaseUrl,
    connectTimeout: httpConnectTimeout,
    receiveTimeout: httpReceiveTimeout,
    headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.acceptHeader: ContentType.json.value,
    },
  );

  if (!dio.interceptors.any((interceptor) => interceptor is AuthInterceptor)) {
    dio.interceptors.add(AuthInterceptor(secureStorage));
  }

  if (!dio.interceptors.any((interceptor) => interceptor is RetryInterceptor)) {
    dio.interceptors.add(RetryInterceptor(dio, networkInfo));
  }

  if (kDebugMode &&
      !dio.interceptors.any(
        (interceptor) => interceptor is PrettyDioLogger,
      )) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  return dio;
}

/// Configures and provides a [Dio] HTTP client with auth, logging and retry.
@singleton
class HttpClient {
  HttpClient(this._dio, this._secureStorage, this._networkInfo) {
    configureDio(
      dio: _dio,
      secureStorage: _secureStorage,
      networkInfo: _networkInfo,
    );
  }

  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final NetworkInfo _networkInfo;

  Dio get dio => _dio;
}

/// Injects Bearer token from secure storage into every request.
/// If no token is stored (e.g. login endpoint), the request proceeds without it.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorage);

  final FlutterSecureStorage _secureStorage;
  static const _tokenKey = 'auth_token';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read(key: _tokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
    handler.next(options);
  }
}

/// Retries the request once on network / timeout errors.
class RetryInterceptor extends Interceptor {
  RetryInterceptor(this._dio, this._networkInfo);

  final Dio _dio;
  final NetworkInfo _networkInfo;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_shouldRetry(err) && (err.requestOptions.extra['retried'] != true)) {
      final isConnected = await _networkInfo.isConnected;
      if (isConnected) {
        err.requestOptions.extra['retried'] = true;
        try {
          final response = await _dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } on DioException catch (e) {
          return handler.next(e);
        }
      }
    }
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError;
  }
}

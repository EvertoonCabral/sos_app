import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/usuario_model.dart';
import 'auth_remote_datasource.dart';

/// Implementação real do [AuthRemoteDatasource] usando Dio.
/// Quando o backend estiver pronto, ajustar a baseUrl e endpoints se necessário.
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  AuthRemoteDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<AuthLoginResponse> login({
    required String email,
    required String senha,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email, 'senha': senha},
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException(
          message: 'Resposta vazia do servidor',
          statusCode: 500,
        );
      }

      return AuthLoginResponse(
        token: data['token'] as String,
        usuario: UsuarioModel.fromJson(data['usuario'] as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ?? 'Erro ao autenticar',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<UsuarioModel> getUsuarioAtual() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/auth/me');

      final data = response.data;
      if (data == null) {
        throw const ServerException(
          message: 'Resposta vazia do servidor',
          statusCode: 500,
        );
      }

      return UsuarioModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ?? 'Erro ao obter usuário',
        statusCode: e.response?.statusCode,
      );
    }
  }
}

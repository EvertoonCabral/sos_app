import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/paged_result.dart';
import '../models/cliente_model.dart';
import 'cliente_remote_datasource.dart';

class ClienteRemoteDatasourceImpl implements ClienteRemoteDatasource {
  ClienteRemoteDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<ClienteModel> criar(ClienteModel model) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/clientes',
        data: model.toJson(),
      );
      return ClienteModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ?? 'Erro ao criar cliente',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<ClienteModel> atualizar(ClienteModel model) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/clientes/${model.id}',
        data: model.toJson(),
      );
      return ClienteModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ??
            'Erro ao atualizar cliente',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<ClienteModel>> buscar(
    String query, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/clientes',
        queryParameters: {
          if (query.trim().isNotEmpty) 'q': query.trim(),
          'page': page,
          'pageSize': pageSize,
        },
      );
      return PagedResult.fromJson(
        response.data!,
        ClienteModel.fromJson,
      ).items;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ??
            'Erro ao buscar clientes',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<ClienteModel> obterPorId(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/clientes/$id');
      return ClienteModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data?['message']?.toString() ?? 'Erro ao obter cliente',
        statusCode: e.response?.statusCode,
      );
    }
  }
}

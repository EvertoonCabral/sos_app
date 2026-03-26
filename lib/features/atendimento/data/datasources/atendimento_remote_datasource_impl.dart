import 'package:dio/dio.dart';

import '../../../../core/network/paged_result.dart';
import '../models/atendimento_model.dart';
import 'atendimento_remote_datasource.dart';

class AtendimentoRemoteDatasourceImpl implements AtendimentoRemoteDatasource {
  AtendimentoRemoteDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<AtendimentoModel> criar(AtendimentoModel model) async {
    final response = await _dio.post('/atendimentos', data: model.toJson());
    return AtendimentoModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<AtendimentoModel>> listarTodos({
    String? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/atendimentos',
      queryParameters: {
        if (status != null && status.isNotEmpty) 'status': status,
        'page': page,
        'pageSize': pageSize,
      },
    );
    return PagedResult.fromJson(
      response.data!,
      AtendimentoModel.fromJson,
    ).items;
  }

  @override
  Future<AtendimentoModel> atualizar(AtendimentoModel model) async {
    final response = await _dio.put(
      '/atendimentos/${model.id}',
      data: model.toJson(),
    );
    return AtendimentoModel.fromJson(response.data as Map<String, dynamic>);
  }
}

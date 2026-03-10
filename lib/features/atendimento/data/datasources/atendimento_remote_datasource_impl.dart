import 'package:dio/dio.dart';

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
  Future<List<AtendimentoModel>> listarTodos() async {
    final response = await _dio.get('/atendimentos');
    final list = response.data as List;
    return list
        .map((e) => AtendimentoModel.fromJson(e as Map<String, dynamic>))
        .toList();
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

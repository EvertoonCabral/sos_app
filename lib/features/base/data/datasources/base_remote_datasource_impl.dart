import 'package:dio/dio.dart';

import 'base_remote_datasource.dart';
import '../models/base_model.dart';

class BaseRemoteDatasourceImpl implements BaseRemoteDatasource {
  BaseRemoteDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<BaseModel> criar(BaseModel model) async {
    final response = await _dio.post('/bases', data: model.toJson());
    return BaseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<BaseModel>> listarTodas() async {
    final response = await _dio.get('/bases');
    final list = response.data as List;
    return list
        .map((e) => BaseModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<BaseModel> definirPrincipal(String id) async {
    final response = await _dio.post('/bases/$id/principal');
    return BaseModel.fromJson(response.data as Map<String, dynamic>);
  }
}

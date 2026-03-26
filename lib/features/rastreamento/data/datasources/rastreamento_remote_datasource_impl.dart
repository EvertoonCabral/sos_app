import 'package:dio/dio.dart';

import '../../../../core/network/paged_result.dart';
import '../models/ponto_rastreamento_model.dart';
import 'rastreamento_remote_datasource.dart';

class RastreamentoRemoteDatasourceImpl implements RastreamentoRemoteDatasource {
  RastreamentoRemoteDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<void> enviarPontos(List<PontoRastreamentoModel> pontos) async {
    await _dio.post(
      '/rastreamento/pontos',
      data: {
        'pontos': pontos.map((ponto) => ponto.toApiJson()).toList(),
      },
    );
  }

  @override
  Future<List<PontoRastreamentoModel>> obterPontosPorAtendimento(
    String atendimentoId, {
    int page = 1,
    int pageSize = 100,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/rastreamento/$atendimentoId',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
      },
    );

    return PagedResult.fromJson(
      response.data!,
      PontoRastreamentoModel.fromJson,
    ).items;
  }
}

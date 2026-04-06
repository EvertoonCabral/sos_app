import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/atendimentos_por_dia_model.dart';
import '../models/resumo_cliente_model.dart';
import '../models/resumo_periodo_model.dart';
import '../models/tempo_por_etapa_model.dart';
import 'dashboard_remote_datasource.dart';

class DashboardRemoteDatasourceImpl implements DashboardRemoteDatasource {
  DashboardRemoteDatasourceImpl(this._dio);

  final Dio _dio;

  String? _extrairMensagem(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map) return data['message']?.toString();
    } catch (_) {}
    return null;
  }

  @override
  Future<ResumoPeriodoModel> obterResumoPeriodo({
    required DateTime inicio,
    required DateTime fim,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/dashboard/resumo',
        queryParameters: _periodoQuery(inicio, fim),
      );
      final data = response.data;
      if (data == null) {
        throw const ServerException(
          message: 'Resposta vazia do dashboard/resumo',
          statusCode: 500,
        );
      }
      return ResumoPeriodoModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(
        message: _extrairMensagem(e) ?? 'Erro ao obter resumo do dashboard',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<ResumoClienteModel>> obterKmPorCliente({
    required DateTime inicio,
    required DateTime fim,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/dashboard/clientes',
        queryParameters: _periodoQuery(inicio, fim),
      );
      return (response.data ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ResumoClienteModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: _extrairMensagem(e) ?? 'Erro ao obter ranking de clientes',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<TempoPorEtapaModel> obterTempoPorEtapa({
    required DateTime inicio,
    required DateTime fim,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/dashboard/etapas',
        queryParameters: _periodoQuery(inicio, fim),
      );
      final data = response.data;
      if (data == null) {
        throw const ServerException(
          message: 'Resposta vazia do dashboard/etapas',
          statusCode: 500,
        );
      }
      return TempoPorEtapaModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(
        message: _extrairMensagem(e) ?? 'Erro ao obter tempo por etapa',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<AtendimentosPorDiaModel>> obterAtendimentosPorDia({
    required DateTime inicio,
    required DateTime fim,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/dashboard/diario',
        queryParameters: _periodoQuery(inicio, fim),
      );
      return (response.data ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(AtendimentosPorDiaModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: _extrairMensagem(e) ?? 'Erro ao obter atendimentos por dia',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Map<String, dynamic> _periodoQuery(DateTime inicio, DateTime fim) => {
        'inicio': inicio.toUtc().toIso8601String(),
        'fim': fim.toUtc().toIso8601String(),
      };
}

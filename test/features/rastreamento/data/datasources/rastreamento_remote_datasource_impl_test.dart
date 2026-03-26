import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/features/rastreamento/data/datasources/rastreamento_remote_datasource_impl.dart';
import 'package:sos_app/features/rastreamento/data/models/ponto_rastreamento_model.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockDio mockDio;
  late RastreamentoRemoteDatasourceImpl datasource;

  final ponto = PontoRastreamentoModel(
    id: 'p-1',
    atendimentoId: 'at-1',
    latitude: -23.55,
    longitude: -46.63,
    accuracy: 10,
    velocidade: 5,
    timestamp: '2024-01-01T10:00:00.000',
  );

  setUp(() {
    mockDio = MockDio();
    datasource = RastreamentoRemoteDatasourceImpl(mockDio);
  });

  test('enviarPontos envia batch no formato do backend', () async {
    when(
      () => mockDio.post(
        '/rastreamento/pontos',
        data: {
          'pontos': [ponto.toApiJson()],
        },
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/rastreamento/pontos'),
        statusCode: 200,
      ),
    );

    await datasource.enviarPontos([ponto]);

    verify(
      () => mockDio.post(
        '/rastreamento/pontos',
        data: {
          'pontos': [ponto.toApiJson()],
        },
      ),
    ).called(1);
  });

  test('obterPontosPorAtendimento parseia PagedResult', () async {
    when(
      () => mockDio.get<Map<String, dynamic>>(
        '/rastreamento/at-1',
        queryParameters: {'page': 1, 'pageSize': 100},
      ),
    ).thenAnswer(
      (_) async => Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: '/rastreamento/at-1'),
        data: {
          'items': [ponto.toApiJson()],
          'page': 1,
          'pageSize': 100,
          'totalCount': 1,
          'totalPages': 1,
          'hasNextPage': false,
          'hasPreviousPage': false,
        },
      ),
    );

    final result = await datasource.obterPontosPorAtendimento('at-1');

    expect(result, hasLength(1));
    expect(result.first.atendimentoId, 'at-1');
  });
}

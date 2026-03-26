import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/features/atendimento/data/datasources/atendimento_remote_datasource_impl.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockDio mockDio;
  late AtendimentoRemoteDatasourceImpl datasource;

  setUp(() {
    mockDio = MockDio();
    datasource = AtendimentoRemoteDatasourceImpl(mockDio);
  });

  test('listarTodos parseia PagedResult com filtro opcional de status',
      () async {
    final local = {
      'enderecoTexto': 'Rua A, 100',
      'latitude': -23.55,
      'longitude': -46.63,
      'complemento': null,
    };

    final response = Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(path: '/atendimentos'),
      data: {
        'items': [
          {
            'id': 'at-1',
            'clienteId': 'c1',
            'usuarioId': 'u1',
            'pontoDeSaida': local,
            'localDeColeta': local,
            'localDeEntrega': local,
            'localDeRetorno': local,
            'distanciaEstimadaKm': 25.0,
            'valorPorKm': 5.0,
            'valorCobrado': 125.0,
            'tipoValor': 'Fixo',
            'status': 'Rascunho',
            'observacoes': 'Teste',
            'criadoEm': '2024-01-01T00:00:00.000',
            'atualizadoEm': '2024-01-01T00:00:00.000',
          }
        ],
        'page': 1,
        'pageSize': 20,
        'totalCount': 1,
        'totalPages': 1,
        'hasNextPage': false,
        'hasPreviousPage': false,
      },
    );

    when(
      () => mockDio.get<Map<String, dynamic>>(
        '/atendimentos',
        queryParameters: {
          'status': 'Rascunho',
          'page': 1,
          'pageSize': 20,
        },
      ),
    ).thenAnswer((_) async => response);

    final result = await datasource.listarTodos(status: 'Rascunho');

    expect(result, hasLength(1));
    expect(result.first.id, 'at-1');
    verify(
      () => mockDio.get<Map<String, dynamic>>(
        '/atendimentos',
        queryParameters: {
          'status': 'Rascunho',
          'page': 1,
          'pageSize': 20,
        },
      ),
    ).called(1);
  });

  test('listarTodos omite status quando não informado', () async {
    final response = Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(path: '/atendimentos'),
      data: {
        'items': [],
        'page': 1,
        'pageSize': 20,
        'totalCount': 0,
        'totalPages': 0,
        'hasNextPage': false,
        'hasPreviousPage': false,
      },
    );

    when(
      () => mockDio.get<Map<String, dynamic>>(
        '/atendimentos',
        queryParameters: {'page': 1, 'pageSize': 20},
      ),
    ).thenAnswer((_) async => response);

    final result = await datasource.listarTodos();

    expect(result, isEmpty);
    verify(
      () => mockDio.get<Map<String, dynamic>>(
        '/atendimentos',
        queryParameters: {'page': 1, 'pageSize': 20},
      ),
    ).called(1);
  });
}

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/features/cliente/data/datasources/cliente_remote_datasource_impl.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockDio mockDio;
  late ClienteRemoteDatasourceImpl datasource;

  setUp(() {
    mockDio = MockDio();
    datasource = ClienteRemoteDatasourceImpl(mockDio);
  });

  test('buscar parseia PagedResult e envia paginação', () async {
    final response = Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(path: '/clientes'),
      data: {
        'items': [
          {
            'id': 'cli-001',
            'nome': 'Maria Silva',
            'telefone': '+5511988880000',
            'documento': '123.456.789-00',
            'enderecoDefault': {
              'enderecoTexto': 'Rua das Flores, 123',
              'latitude': -23.5,
              'longitude': -46.6,
              'complemento': 'Apto 42',
            },
            'criadoEm': '2026-03-01T00:00:00.000',
            'atualizadoEm': '2026-03-01T00:00:00.000',
            'sincronizadoEm': null,
          }
        ],
        'page': 2,
        'pageSize': 50,
        'totalCount': 87,
        'totalPages': 2,
        'hasNextPage': false,
        'hasPreviousPage': true,
      },
    );

    when(
      () => mockDio.get<Map<String, dynamic>>(
        '/clientes',
        queryParameters: {'q': 'Maria', 'page': 2, 'pageSize': 50},
      ),
    ).thenAnswer((_) async => response);

    final result = await datasource.buscar('Maria', page: 2, pageSize: 50);

    expect(result, hasLength(1));
    expect(result.first.id, 'cli-001');
    verify(
      () => mockDio.get<Map<String, dynamic>>(
        '/clientes',
        queryParameters: {'q': 'Maria', 'page': 2, 'pageSize': 50},
      ),
    ).called(1);
  });

  test('buscar omite q quando query estiver vazia', () async {
    final response = Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(path: '/clientes'),
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
        '/clientes',
        queryParameters: {'page': 1, 'pageSize': 20},
      ),
    ).thenAnswer((_) async => response);

    final result = await datasource.buscar('   ');

    expect(result, isEmpty);
    verify(
      () => mockDio.get<Map<String, dynamic>>(
        '/clientes',
        queryParameters: {'page': 1, 'pageSize': 20},
      ),
    ).called(1);
  });
}

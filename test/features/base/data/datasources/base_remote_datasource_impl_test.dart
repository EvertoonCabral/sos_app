import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/features/base/data/datasources/base_remote_datasource_impl.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockDio mockDio;
  late BaseRemoteDatasourceImpl datasource;

  setUp(() {
    mockDio = MockDio();
    datasource = BaseRemoteDatasourceImpl(mockDio);
  });

  test('definirPrincipal usa POST no endpoint principal', () async {
    final response = Response(
      requestOptions: RequestOptions(path: '/bases/base-1/principal'),
      data: {
        'id': 'base-1',
        'nome': 'Garagem SP',
        'local': {
          'enderecoTexto': 'Rua X, 100',
          'latitude': -23.5,
          'longitude': -46.6,
          'complemento': null,
        },
        'isPrincipal': true,
        'criadoEm': '2026-03-01T00:00:00.000',
      },
    );

    when(() => mockDio.post('/bases/base-1/principal'))
        .thenAnswer((_) async => response);

    final result = await datasource.definirPrincipal('base-1');

    expect(result.id, 'base-1');
    expect(result.isPrincipal, isTrue);
    verify(() => mockDio.post('/bases/base-1/principal')).called(1);
    verifyNever(() => mockDio.put(any()));
  });
}

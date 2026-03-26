import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/error/exceptions.dart';
import 'package:sos_app/features/auth/data/datasources/auth_remote_datasource_impl.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late AuthRemoteDatasourceImpl datasource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    datasource = AuthRemoteDatasourceImpl(mockDio);
    registerFallbackValue(RequestOptions(path: ''));
  });

  test('login deve parsear LoginResponse flat', () async {
    when(() => mockDio.post<Map<String, dynamic>>(
          '/auth/login',
          data: {'email': 'teste@x.com', 'senha': '123'},
        )).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/auth/login'),
        statusCode: 200,
        data: {
          'token': 'jwt',
          'usuarioId': 'u1',
          'nome': 'Teste',
          'email': 'teste@x.com',
          'role': 'operador',
          'expiresAt': '2026-03-26T12:00:00.000Z',
        },
      ),
    );

    final result = await datasource.login(email: 'teste@x.com', senha: '123');

    expect(result.token, 'jwt');
    expect(result.usuarioId, 'u1');
  });

  test('refresh deve parsear LoginResponse flat', () async {
    when(() => mockDio.post<Map<String, dynamic>>('/auth/refresh')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/auth/refresh'),
        statusCode: 200,
        data: {
          'token': 'novo-jwt',
          'usuarioId': 'u1',
          'nome': 'Teste',
          'email': 'teste@x.com',
          'role': 'operador',
          'expiresAt': '2026-03-26T13:00:00.000Z',
        },
      ),
    );

    final result = await datasource.refresh();

    expect(result.token, 'novo-jwt');
    expect(result.role, 'operador');
  });

  test('getUsuarioAtual deve parsear UsuarioAtualResponse flat', () async {
    when(() => mockDio.get<Map<String, dynamic>>('/auth/me')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/auth/me'),
        statusCode: 200,
        data: {
          'usuarioId': 'u1',
          'nome': 'Teste',
          'email': 'teste@x.com',
          'role': 'operador',
          'valorPorKmDefault': 7.5,
        },
      ),
    );

    final result = await datasource.getUsuarioAtual();

    expect(result.id, 'u1');
    expect(result.valorPorKmDefault, 7.5);
  });

  test('refresh deve lançar ServerException em erro', () async {
    when(() => mockDio.post<Map<String, dynamic>>('/auth/refresh')).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/auth/refresh'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/refresh'),
          statusCode: 401,
          data: {'message': 'Não autorizado'},
        ),
      ),
    );

    expect(
      () => datasource.refresh(),
      throwsA(isA<ServerException>()),
    );
  });
}

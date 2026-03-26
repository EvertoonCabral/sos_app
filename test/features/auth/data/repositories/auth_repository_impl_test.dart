import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/error/exceptions.dart';
import 'package:sos_app/core/error/failures.dart';
import 'package:sos_app/core/network/network_info.dart';
import 'package:sos_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:sos_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:sos_app/features/auth/data/models/usuario_model.dart';
import 'package:sos_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sos_app/features/auth/domain/entities/usuario.dart';

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

class MockAuthLocalDatasource extends Mock implements AuthLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDatasource mockRemote;
  late MockAuthLocalDatasource mockLocal;
  late MockNetworkInfo mockNetwork;

  const tModel = UsuarioModel(
    id: 'user-123',
    nome: 'João Operador',
    telefone: '+5511999990000',
    email: 'joao@guincho.com',
    role: 'operador',
    valorPorKmDefault: 5.0,
    criadoEm: '2026-03-01T00:00:00.000',
  );

  final tEntity = Usuario(
    id: 'user-123',
    nome: 'João Operador',
    telefone: '+5511999990000',
    email: 'joao@guincho.com',
    role: UsuarioRole.operador,
    valorPorKmDefault: 5.0,
    criadoEm: DateTime(2026, 3, 1),
  );

  const tToken = 'jwt-token-abc';
  const tEmail = 'joao@guincho.com';
  const tSenha = 'senha123';

  final tLoginResponse = AuthLoginResponse(
    token: tToken,
    usuarioId: 'user-123',
    nome: 'João Operador',
    email: 'joao@guincho.com',
    role: 'operador',
    expiresAt: DateTime(2026, 4, 1),
  );

  setUp(() {
    mockRemote = MockAuthRemoteDatasource();
    mockLocal = MockAuthLocalDatasource();
    mockNetwork = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDatasource: mockRemote,
      localDatasource: mockLocal,
      networkInfo: mockNetwork,
    );

    registerFallbackValue(tModel);
  });

  // ─── autenticar ─────────────────────────────────────────────

  group('autenticar', () {
    test('deve retornar Usuario quando online e login bem-sucedido', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemote.login(email: tEmail, senha: tSenha),
      ).thenAnswer((_) async => tLoginResponse);
      when(
        () => mockRemote.getUsuarioAtual(),
      ).thenAnswer((_) async => tModel);
      when(
        () => mockLocal.salvarToken(tToken),
      ).thenAnswer((_) async {});
      when(
        () => mockLocal.salvarUsuario(tModel),
      ).thenAnswer((_) async {});

      final result = await repository.autenticar(
        email: tEmail,
        senha: tSenha,
      );

      expect(result, tEntity);
      verify(() => mockLocal.salvarToken(tToken)).called(1);
      verify(() => mockLocal.salvarUsuario(tModel)).called(1);
    });

    test('deve salvar usuário parcial quando getUsuarioAtual falha', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemote.login(email: tEmail, senha: tSenha),
      ).thenAnswer((_) async => tLoginResponse);
      when(
        () => mockRemote.getUsuarioAtual(),
      ).thenThrow(
        const ServerException(message: 'Falha no me', statusCode: 500),
      );
      when(
        () => mockLocal.salvarToken(tToken),
      ).thenAnswer((_) async {});
      when(
        () => mockLocal.salvarUsuario(any()),
      ).thenAnswer((_) async {});

      final result = await repository.autenticar(
        email: tEmail,
        senha: tSenha,
      );

      expect(result.id, 'user-123');
      expect(result.nome, 'João Operador');
      verify(() => mockLocal.salvarUsuario(any())).called(1);
    });

    test('deve lançar NetworkFailure quando offline', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);

      expect(
        () => repository.autenticar(email: tEmail, senha: tSenha),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('deve lançar ServerFailure quando remote lança ServerException',
        () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemote.login(email: tEmail, senha: tSenha),
      ).thenThrow(
        const ServerException(
            message: 'Credenciais inválidas', statusCode: 401),
      );

      expect(
        () => repository.autenticar(email: tEmail, senha: tSenha),
        throwsA(isA<ServerFailure>()),
      );
    });
  });

  // ─── obterUsuarioLogado ─────────────────────────────────────

  group('obterUsuarioLogado', () {
    test('deve retornar null quando não há token salvo', () async {
      when(() => mockLocal.obterToken()).thenAnswer((_) async => null);

      final result = await repository.obterUsuarioLogado();

      expect(result, isNull);
      verifyNever(() => mockRemote.getUsuarioAtual());
    });

    test('deve retornar usuario do remote quando online com token', () async {
      when(() => mockLocal.obterToken()).thenAnswer((_) async => tToken);
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemote.getUsuarioAtual(),
      ).thenAnswer((_) async => tModel);
      when(
        () => mockLocal.salvarUsuario(tModel),
      ).thenAnswer((_) async {});

      final result = await repository.obterUsuarioLogado();

      expect(result, tEntity);
      verify(() => mockLocal.salvarUsuario(tModel)).called(1);
    });

    test(
        'deve limpar dados e retornar null quando remote lança ServerException',
        () async {
      when(() => mockLocal.obterToken()).thenAnswer((_) async => tToken);
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemote.getUsuarioAtual(),
      ).thenThrow(
        const ServerException(message: 'Token expirado', statusCode: 401),
      );
      when(() => mockLocal.limparDados()).thenAnswer((_) async {});

      final result = await repository.obterUsuarioLogado();

      expect(result, isNull);
      verify(() => mockLocal.limparDados()).called(1);
    });

    test('deve retornar cache local quando offline com token', () async {
      when(() => mockLocal.obterToken()).thenAnswer((_) async => tToken);
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocal.obterUsuario(),
      ).thenAnswer((_) async => tModel);

      final result = await repository.obterUsuarioLogado();

      expect(result, tEntity);
      verifyNever(() => mockRemote.getUsuarioAtual());
    });
  });

  // ─── logout ─────────────────────────────────────────────────

  group('logout', () {
    test('deve chamar limparDados do local datasource', () async {
      when(() => mockLocal.limparDados()).thenAnswer((_) async {});

      await repository.logout();

      verify(() => mockLocal.limparDados()).called(1);
    });
  });

  // ─── salvarToken e obterToken ───────────────────────────────

  group('salvarToken', () {
    test('deve delegar para local datasource', () async {
      when(
        () => mockLocal.salvarToken(tToken),
      ).thenAnswer((_) async {});

      await repository.salvarToken(tToken);

      verify(() => mockLocal.salvarToken(tToken)).called(1);
    });
  });

  group('obterToken', () {
    test('deve retornar token do local datasource', () async {
      when(() => mockLocal.obterToken()).thenAnswer((_) async => tToken);

      final result = await repository.obterToken();

      expect(result, tToken);
    });
  });
}

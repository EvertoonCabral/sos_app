import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/error/failures.dart';
import 'package:sos_app/features/auth/domain/entities/usuario.dart';
import 'package:sos_app/features/auth/domain/usecases/autenticar_usuario.dart';
import 'package:sos_app/features/auth/domain/usecases/obter_usuario_logado.dart';
import 'package:sos_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:sos_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sos_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:sos_app/features/auth/presentation/bloc/auth_state.dart';

class MockAutenticarUsuario extends Mock implements AutenticarUsuario {}

class MockObterUsuarioLogado extends Mock implements ObterUsuarioLogado {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthBloc bloc;
  late MockAutenticarUsuario mockAutenticar;
  late MockObterUsuarioLogado mockObterLogado;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockAutenticar = MockAutenticarUsuario();
    mockObterLogado = MockObterUsuarioLogado();
    mockRepository = MockAuthRepository();
    bloc = AuthBloc(
      autenticarUsuario: mockAutenticar,
      obterUsuarioLogado: mockObterLogado,
      authRepository: mockRepository,
    );
  });

  tearDown(() => bloc.close());

  final tUsuario = Usuario(
    id: 'user-123',
    nome: 'João Operador',
    telefone: '+5511999990000',
    email: 'joao@guincho.com',
    role: UsuarioRole.operador,
    valorPorKmDefault: 5.0,
    criadoEm: DateTime(2026, 3, 1),
  );

  test('estado inicial deve ser AuthInicial', () {
    expect(bloc.state, const AuthInicial());
  });

  // ─── LoginSolicitado ────────────────────────────────────────

  group('LoginSolicitado', () {
    const tEmail = 'joao@guincho.com';
    const tSenha = 'senha123';
    const tParams = AutenticarUsuarioParams(email: tEmail, senha: tSenha);

    blocTest<AuthBloc, AuthState>(
      'deve emitir [Carregando, Autenticado] quando login sucesso',
      build: () {
        when(() => mockAutenticar(tParams)).thenAnswer((_) async => tUsuario);
        return bloc;
      },
      act: (b) => b.add(const LoginSolicitado(email: tEmail, senha: tSenha)),
      expect: () => [
        const AuthCarregando(),
        AuthAutenticado(tUsuario),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'deve emitir [Carregando, Erro] quando login falha com ServerFailure',
      build: () {
        when(() => mockAutenticar(tParams))
            .thenThrow(const ServerFailure(message: 'Credenciais inválidas'));
        return bloc;
      },
      act: (b) => b.add(const LoginSolicitado(email: tEmail, senha: tSenha)),
      expect: () => [
        const AuthCarregando(),
        const AuthErro('Credenciais inválidas'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'deve emitir [Carregando, Erro] quando login falha com ValidationFailure',
      build: () {
        when(() => mockAutenticar(tParams)).thenThrow(
            const ValidationFailure(message: 'Email não pode ser vazio'));
        return bloc;
      },
      act: (b) => b.add(const LoginSolicitado(email: tEmail, senha: tSenha)),
      expect: () => [
        const AuthCarregando(),
        const AuthErro('Email não pode ser vazio'),
      ],
    );
  });

  // ─── SessaoVerificada ───────────────────────────────────────

  group('SessaoVerificada', () {
    blocTest<AuthBloc, AuthState>(
      'deve emitir [Carregando, Autenticado] quando há sessão ativa',
      build: () {
        when(() => mockObterLogado()).thenAnswer((_) async => tUsuario);
        return bloc;
      },
      act: (b) => b.add(const SessaoVerificada()),
      expect: () => [
        const AuthCarregando(),
        AuthAutenticado(tUsuario),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'deve emitir [Carregando, NaoAutenticado] quando não há sessão',
      build: () {
        when(() => mockObterLogado()).thenAnswer((_) async => null);
        return bloc;
      },
      act: (b) => b.add(const SessaoVerificada()),
      expect: () => [
        const AuthCarregando(),
        const AuthNaoAutenticado(),
      ],
    );
  });

  // ─── LogoutSolicitado ───────────────────────────────────────

  group('LogoutSolicitado', () {
    blocTest<AuthBloc, AuthState>(
      'deve emitir [NaoAutenticado] e chamar repository.logout',
      build: () {
        when(() => mockRepository.logout()).thenAnswer((_) async {});
        return bloc;
      },
      act: (b) => b.add(const LogoutSolicitado()),
      expect: () => [const AuthNaoAutenticado()],
      verify: (_) {
        verify(() => mockRepository.logout()).called(1);
      },
    );
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/error/failures.dart';
import 'package:sos_app/features/auth/domain/entities/usuario.dart';
import 'package:sos_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:sos_app/features/auth/domain/usecases/autenticar_usuario.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AutenticarUsuario usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = AutenticarUsuario(mockRepository);
  });

  final tCriadoEm = DateTime(2026, 3, 1);

  final tUsuario = Usuario(
    id: 'user-123',
    nome: 'João Operador',
    telefone: '+5511999990000',
    email: 'joao@guincho.com',
    role: UsuarioRole.operador,
    valorPorKmDefault: 5.0,
    criadoEm: tCriadoEm,
  );

  const tEmail = 'joao@guincho.com';
  const tSenha = 'senha123';

  group('AutenticarUsuario', () {
    test('deve retornar Usuario quando autenticação for bem-sucedida',
        () async {
      when(
        () => mockRepository.autenticar(email: tEmail, senha: tSenha),
      ).thenAnswer((_) async => tUsuario);

      final result = await usecase(
        const AutenticarUsuarioParams(email: tEmail, senha: tSenha),
      );

      expect(result, tUsuario);
      verify(() => mockRepository.autenticar(email: tEmail, senha: tSenha))
          .called(1);
    });

    test('deve propagar exceção quando repositório falha', () async {
      when(
        () => mockRepository.autenticar(email: tEmail, senha: tSenha),
      ).thenThrow(const ServerFailure(message: 'Credenciais inválidas'));

      expect(
        () => usecase(
          const AutenticarUsuarioParams(email: tEmail, senha: tSenha),
        ),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('deve lançar ValidationFailure se email estiver vazio', () async {
      expect(
        () => usecase(const AutenticarUsuarioParams(email: '', senha: tSenha)),
        throwsA(isA<ValidationFailure>()),
      );

      verifyNever(
        () => mockRepository.autenticar(
            email: any(named: 'email'), senha: any(named: 'senha')),
      );
    });

    test('deve lançar ValidationFailure se senha estiver vazia', () async {
      expect(
        () => usecase(const AutenticarUsuarioParams(email: tEmail, senha: '')),
        throwsA(isA<ValidationFailure>()),
      );

      verifyNever(
        () => mockRepository.autenticar(
            email: any(named: 'email'), senha: any(named: 'senha')),
      );
    });
  });
}

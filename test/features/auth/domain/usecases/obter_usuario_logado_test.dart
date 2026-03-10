import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/features/auth/domain/entities/usuario.dart';
import 'package:sos_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:sos_app/features/auth/domain/usecases/obter_usuario_logado.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ObterUsuarioLogado usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = ObterUsuarioLogado(mockRepository);
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

  group('ObterUsuarioLogado', () {
    test('deve retornar Usuario quando há sessão ativa', () async {
      when(() => mockRepository.obterUsuarioLogado())
          .thenAnswer((_) async => tUsuario);

      final result = await usecase();

      expect(result, tUsuario);
      verify(() => mockRepository.obterUsuarioLogado()).called(1);
    });

    test('deve retornar null quando não há sessão ativa', () async {
      when(() => mockRepository.obterUsuarioLogado())
          .thenAnswer((_) async => null);

      final result = await usecase();

      expect(result, isNull);
      verify(() => mockRepository.obterUsuarioLogado()).called(1);
    });
  });
}

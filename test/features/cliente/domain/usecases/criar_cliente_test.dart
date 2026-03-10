import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/error/failures.dart';
import 'package:sos_app/features/cliente/domain/entities/cliente.dart';
import 'package:sos_app/features/cliente/domain/repositories/cliente_repository.dart';
import 'package:sos_app/features/cliente/domain/usecases/criar_cliente.dart';

class MockClienteRepository extends Mock implements ClienteRepository {}

void main() {
  late CriarCliente usecase;
  late MockClienteRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(
      Cliente(
        id: 'fallback',
        nome: 'fallback',
        telefone: '000',
        criadoEm: DateTime(2026, 1, 1),
        atualizadoEm: DateTime(2026, 1, 1),
      ),
    );
  });

  setUp(() {
    mockRepository = MockClienteRepository();
    usecase = CriarCliente(mockRepository);
  });

  final tCliente = Cliente(
    id: 'cli-001',
    nome: 'Maria Silva',
    telefone: '+5511988880000',
    criadoEm: DateTime(2026, 3, 1),
    atualizadoEm: DateTime(2026, 3, 1),
  );

  group('CriarCliente', () {
    test('deve criar cliente quando dados válidos', () async {
      when(() => mockRepository.criar(any())).thenAnswer((_) async => tCliente);

      final result = await usecase(
        const CriarClienteParams(
          id: 'cli-001',
          nome: 'Maria Silva',
          telefone: '+5511988880000',
        ),
      );

      expect(result.nome, 'Maria Silva');
      verify(() => mockRepository.criar(any())).called(1);
    });

    test('deve lançar ValidationFailure quando nome vazio', () async {
      expect(
        () => usecase(
          const CriarClienteParams(
            id: 'cli-001',
            nome: '',
            telefone: '+5511988880000',
          ),
        ),
        throwsA(isA<ValidationFailure>()),
      );
      verifyNever(() => mockRepository.criar(any()));
    });

    test('deve lançar ValidationFailure quando telefone vazio', () async {
      expect(
        () => usecase(
          const CriarClienteParams(
            id: 'cli-001',
            nome: 'Maria Silva',
            telefone: '',
          ),
        ),
        throwsA(isA<ValidationFailure>()),
      );
      verifyNever(() => mockRepository.criar(any()));
    });

    test('deve criar cliente com documento opcional', () async {
      when(() => mockRepository.criar(any())).thenAnswer((_) async => tCliente);

      final result = await usecase(
        const CriarClienteParams(
          id: 'cli-001',
          nome: 'Maria Silva',
          telefone: '+5511988880000',
          documento: '123.456.789-00',
        ),
      );

      expect(result, tCliente);
    });

    test('deve fazer trim nos campos antes de criar', () async {
      when(() => mockRepository.criar(any())).thenAnswer((_) async {
        final captured = verify(() => mockRepository.criar(captureAny()))
            .captured
            .single as Cliente;
        return captured;
      });

      final result = await usecase(
        const CriarClienteParams(
          id: 'cli-001',
          nome: '  Maria Silva  ',
          telefone: '  +5511988880000  ',
        ),
      );

      expect(result.nome, 'Maria Silva');
      expect(result.telefone, '+5511988880000');
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/error/failures.dart';
import 'package:sos_app/features/cliente/domain/entities/cliente.dart';
import 'package:sos_app/features/cliente/domain/repositories/cliente_repository.dart';
import 'package:sos_app/features/cliente/domain/usecases/atualizar_cliente.dart';

class MockClienteRepository extends Mock implements ClienteRepository {}

void main() {
  late AtualizarCliente usecase;
  late MockClienteRepository mockRepository;

  setUp(() {
    mockRepository = MockClienteRepository();
    usecase = AtualizarCliente(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      Cliente(
        id: 'cli-001',
        nome: 'fallback',
        telefone: '000',
        criadoEm: DateTime(2026, 1, 1),
        atualizadoEm: DateTime(2026, 1, 1),
      ),
    );
  });

  final tCliente = Cliente(
    id: 'cli-001',
    nome: 'Maria Silva',
    telefone: '+5511988880000',
    criadoEm: DateTime(2026, 3, 1),
    atualizadoEm: DateTime(2026, 3, 1),
  );

  group('AtualizarCliente', () {
    test('deve atualizar cliente quando dados válidos', () async {
      when(() => mockRepository.atualizar(any()))
          .thenAnswer((_) async => tCliente);

      final result = await usecase(tCliente);

      expect(result, tCliente);
      verify(() => mockRepository.atualizar(any())).called(1);
    });

    test('deve lançar ValidationFailure quando nome vazio', () async {
      final clienteInvalido = tCliente.copyWith(nome: '');

      expect(
        () => usecase(clienteInvalido),
        throwsA(isA<ValidationFailure>()),
      );
      verifyNever(() => mockRepository.atualizar(any()));
    });

    test('deve lançar ValidationFailure quando telefone vazio', () async {
      final clienteInvalido = tCliente.copyWith(telefone: '');

      expect(
        () => usecase(clienteInvalido),
        throwsA(isA<ValidationFailure>()),
      );
      verifyNever(() => mockRepository.atualizar(any()));
    });

    test('deve atualizar o campo atualizadoEm ao chamar', () async {
      when(() => mockRepository.atualizar(any())).thenAnswer((inv) async {
        final c = inv.positionalArguments[0] as Cliente;
        return c;
      });

      final result = await usecase(tCliente);

      // atualizadoEm deve ser diferente do original (mais recente)
      expect(result.atualizadoEm.isAfter(tCliente.atualizadoEm), isTrue);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/features/cliente/domain/entities/cliente.dart';
import 'package:sos_app/features/cliente/domain/repositories/cliente_repository.dart';
import 'package:sos_app/features/cliente/domain/usecases/buscar_clientes.dart';

class MockClienteRepository extends Mock implements ClienteRepository {}

void main() {
  late BuscarClientes usecase;
  late MockClienteRepository mockRepository;

  setUp(() {
    mockRepository = MockClienteRepository();
    usecase = BuscarClientes(mockRepository);
  });

  final tClientes = [
    Cliente(
      id: 'cli-001',
      nome: 'Maria Silva',
      telefone: '+5511988880000',
      criadoEm: DateTime(2026, 3, 1),
      atualizadoEm: DateTime(2026, 3, 1),
    ),
    Cliente(
      id: 'cli-002',
      nome: 'João Santos',
      telefone: '+5511977770000',
      criadoEm: DateTime(2026, 3, 2),
      atualizadoEm: DateTime(2026, 3, 2),
    ),
  ];

  group('BuscarClientes', () {
    test('deve retornar lista de clientes quando busca com query', () async {
      when(() => mockRepository.buscar('Maria'))
          .thenAnswer((_) async => [tClientes[0]]);

      final result = await usecase('Maria');

      expect(result, [tClientes[0]]);
      verify(() => mockRepository.buscar('Maria')).called(1);
    });

    test('deve retornar todos quando query vazia', () async {
      when(() => mockRepository.listarTodos())
          .thenAnswer((_) async => tClientes);

      final result = await usecase('');

      expect(result, tClientes);
      verify(() => mockRepository.listarTodos()).called(1);
      verifyNever(() => mockRepository.buscar(any()));
    });

    test('deve retornar todos quando query só com espaços', () async {
      when(() => mockRepository.listarTodos())
          .thenAnswer((_) async => tClientes);

      final result = await usecase('   ');

      expect(result, tClientes);
      verify(() => mockRepository.listarTodos()).called(1);
    });

    test('deve retornar lista vazia quando nenhum resultado', () async {
      when(() => mockRepository.buscar('xyz')).thenAnswer((_) async => []);

      final result = await usecase('xyz');

      expect(result, isEmpty);
    });

    test('deve fazer trim na query antes de buscar', () async {
      when(() => mockRepository.buscar('Maria'))
          .thenAnswer((_) async => [tClientes[0]]);

      await usecase('  Maria  ');

      verify(() => mockRepository.buscar('Maria')).called(1);
    });
  });
}

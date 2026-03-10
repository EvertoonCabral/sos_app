import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/sync/sync_queue_datasource.dart';
import 'package:sos_app/features/cliente/data/datasources/cliente_local_datasource.dart';
import 'package:sos_app/features/cliente/data/models/cliente_model.dart';
import 'package:sos_app/features/cliente/data/repositories/cliente_repository_impl.dart';
import 'package:sos_app/features/cliente/domain/entities/cliente.dart';

class MockClienteLocalDatasource extends Mock
    implements ClienteLocalDatasource {}

class MockSyncQueueDatasource extends Mock implements SyncQueueDatasource {}

void main() {
  late ClienteRepositoryImpl repository;
  late MockClienteLocalDatasource mockLocal;
  late MockSyncQueueDatasource mockSyncQueue;

  setUp(() {
    mockLocal = MockClienteLocalDatasource();
    mockSyncQueue = MockSyncQueueDatasource();
    repository = ClienteRepositoryImpl(
      localDatasource: mockLocal,
      syncQueue: mockSyncQueue,
    );
  });

  setUpAll(() {
    registerFallbackValue(
      const ClienteModel(
        id: 'fb',
        nome: 'fb',
        telefone: '0',
        criadoEm: '2026-01-01T00:00:00.000',
        atualizadoEm: '2026-01-01T00:00:00.000',
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

  const tModel = ClienteModel(
    id: 'cli-001',
    nome: 'Maria Silva',
    telefone: '+5511988880000',
    criadoEm: '2026-03-01T00:00:00.000',
    atualizadoEm: '2026-03-01T00:00:00.000',
  );

  // ─── criar ──────────────────────────────────────────────────

  group('criar', () {
    test('deve inserir no local e adicionar à sync queue', () async {
      when(() => mockLocal.inserir(any())).thenAnswer((_) async {});
      when(
        () => mockSyncQueue.adicionar(
          entidade: any(named: 'entidade'),
          operacao: any(named: 'operacao'),
          payload: any(named: 'payload'),
        ),
      ).thenAnswer((_) async {});

      final result = await repository.criar(tCliente);

      expect(result, tCliente);
      verify(() => mockLocal.inserir(any())).called(1);
      verify(
        () => mockSyncQueue.adicionar(
          entidade: 'cliente',
          operacao: 'create',
          payload: any(named: 'payload'),
        ),
      ).called(1);
    });
  });

  // ─── atualizar ──────────────────────────────────────────────

  group('atualizar', () {
    test('deve atualizar no local e adicionar à sync queue', () async {
      when(() => mockLocal.atualizar(any())).thenAnswer((_) async {});
      when(
        () => mockSyncQueue.adicionar(
          entidade: any(named: 'entidade'),
          operacao: any(named: 'operacao'),
          payload: any(named: 'payload'),
        ),
      ).thenAnswer((_) async {});

      final result = await repository.atualizar(tCliente);

      expect(result, tCliente);
      verify(() => mockLocal.atualizar(any())).called(1);
      verify(
        () => mockSyncQueue.adicionar(
          entidade: 'cliente',
          operacao: 'update',
          payload: any(named: 'payload'),
        ),
      ).called(1);
    });
  });

  // ─── buscar ─────────────────────────────────────────────────

  group('buscar', () {
    test('deve retornar lista de entidades do local', () async {
      when(() => mockLocal.buscar('Maria')).thenAnswer((_) async => [tModel]);

      final result = await repository.buscar('Maria');

      expect(result.length, 1);
      expect(result[0].id, 'cli-001');
      verify(() => mockLocal.buscar('Maria')).called(1);
    });

    test('deve retornar lista vazia quando nenhum resultado', () async {
      when(() => mockLocal.buscar('xyz')).thenAnswer((_) async => []);

      final result = await repository.buscar('xyz');

      expect(result, isEmpty);
    });
  });

  // ─── obterPorId ─────────────────────────────────────────────

  group('obterPorId', () {
    test('deve retornar cliente quando encontrado', () async {
      when(() => mockLocal.obterPorId('cli-001'))
          .thenAnswer((_) async => tModel);

      final result = await repository.obterPorId('cli-001');

      expect(result, isNotNull);
      expect(result!.id, 'cli-001');
    });

    test('deve retornar null quando não encontrado', () async {
      when(() => mockLocal.obterPorId('xxx')).thenAnswer((_) async => null);

      final result = await repository.obterPorId('xxx');

      expect(result, isNull);
    });
  });

  // ─── listarTodos ────────────────────────────────────────────

  group('listarTodos', () {
    test('deve retornar todos os clientes do local', () async {
      when(() => mockLocal.listarTodos()).thenAnswer((_) async => [tModel]);

      final result = await repository.listarTodos();

      expect(result.length, 1);
      verify(() => mockLocal.listarTodos()).called(1);
    });
  });
}

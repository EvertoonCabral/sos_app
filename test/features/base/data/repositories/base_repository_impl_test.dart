import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/entities/local_geo.dart';
import 'package:sos_app/core/sync/sync_queue_datasource.dart';
import 'package:sos_app/features/base/data/datasources/base_local_datasource.dart';
import 'package:sos_app/features/base/data/models/base_model.dart';
import 'package:sos_app/features/base/data/repositories/base_repository_impl.dart';
import 'package:sos_app/features/base/domain/entities/base.dart';

class MockBaseLocalDatasource extends Mock implements BaseLocalDatasource {}

class MockSyncQueueDatasource extends Mock implements SyncQueueDatasource {}

void main() {
  late BaseRepositoryImpl repository;
  late MockBaseLocalDatasource mockLocal;
  late MockSyncQueueDatasource mockSyncQueue;

  setUp(() {
    mockLocal = MockBaseLocalDatasource();
    mockSyncQueue = MockSyncQueueDatasource();
    repository = BaseRepositoryImpl(
      localDatasource: mockLocal,
      syncQueue: mockSyncQueue,
    );
  });

  setUpAll(() {
    registerFallbackValue(
      const BaseModel(
        id: 'fb',
        nome: 'fb',
        localJson: '{}',
        criadoEm: '2026-01-01T00:00:00.000',
      ),
    );
  });

  final tBase = Base(
    id: 'base-001',
    nome: 'Garagem SP',
    local: const LocalGeo(
      enderecoTexto: 'Rua X, 100',
      latitude: -23.5,
      longitude: -46.6,
    ),
    criadoEm: DateTime(2026, 3, 1),
  );

  const tModel = BaseModel(
    id: 'base-001',
    nome: 'Garagem SP',
    localJson:
        '{"endereco_texto":"Rua X, 100","latitude":-23.5,"longitude":-46.6,"complemento":null}',
    isPrincipal: true,
    criadoEm: '2026-03-01T00:00:00.000',
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

      final result = await repository.criar(tBase);

      expect(result, tBase);
      verify(() => mockLocal.inserir(any())).called(1);
      verify(
        () => mockSyncQueue.adicionar(
          entidade: 'base',
          operacao: 'create',
          payload: any(named: 'payload'),
        ),
      ).called(1);
    });
  });

  // ─── listarTodas ────────────────────────────────────────────

  group('listarTodas', () {
    test('deve retornar todas as bases do local', () async {
      when(() => mockLocal.listarTodas()).thenAnswer((_) async => [tModel]);

      final result = await repository.listarTodas();

      expect(result.length, 1);
      expect(result[0].id, 'base-001');
      verify(() => mockLocal.listarTodas()).called(1);
    });
  });

  // ─── definirPrincipal ───────────────────────────────────────

  group('definirPrincipal', () {
    test('deve setar principal no local, sync queue, e retornar base',
        () async {
      when(() => mockLocal.definirPrincipal('base-001'))
          .thenAnswer((_) async {});
      when(() => mockLocal.obterPorId('base-001'))
          .thenAnswer((_) async => tModel);
      when(
        () => mockSyncQueue.adicionar(
          entidade: any(named: 'entidade'),
          operacao: any(named: 'operacao'),
          payload: any(named: 'payload'),
        ),
      ).thenAnswer((_) async {});

      final result = await repository.definirPrincipal('base-001');

      expect(result.isPrincipal, true);
      verify(() => mockLocal.definirPrincipal('base-001')).called(1);
      verify(
        () => mockSyncQueue.adicionar(
          entidade: 'base',
          operacao: 'set_principal',
          payload: any(named: 'payload'),
        ),
      ).called(1);
    });
  });
}

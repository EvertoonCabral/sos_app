import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/sync/sync_queue_datasource.dart';
import 'package:sos_app/features/rastreamento/data/datasources/rastreamento_local_datasource.dart';
import 'package:sos_app/features/rastreamento/data/models/ponto_rastreamento_model.dart';
import 'package:sos_app/features/rastreamento/data/repositories/rastreamento_repository_impl.dart';
import 'package:sos_app/features/rastreamento/domain/entities/ponto_rastreamento.dart';

class MockLocalDatasource extends Mock implements RastreamentoLocalDatasource {}

class MockSyncQueue extends Mock implements SyncQueueDatasource {}

void main() {
  late RastreamentoRepositoryImpl repository;
  late MockLocalDatasource mockLocal;
  late MockSyncQueue mockSyncQueue;

  final ponto = PontoRastreamento(
    id: 'p-1',
    atendimentoId: 'at-1',
    latitude: -23.55,
    longitude: -46.63,
    accuracy: 10.0,
    velocidade: 5.0,
    timestamp: DateTime(2024, 1, 1, 10, 0),
  );

  final model = PontoRastreamentoModel.fromEntity(ponto);

  setUp(() {
    mockLocal = MockLocalDatasource();
    mockSyncQueue = MockSyncQueue();
    repository = RastreamentoRepositoryImpl(
      localDatasource: mockLocal,
      syncQueue: mockSyncQueue,
    );

    registerFallbackValue(model);
  });

  group('RastreamentoRepositoryImpl', () {
    test('salvarPonto insere no local e adiciona à sync queue', () async {
      when(() => mockLocal.inserir(any())).thenAnswer((_) async {});
      when(() => mockSyncQueue.adicionar(
            entidade: any(named: 'entidade'),
            operacao: any(named: 'operacao'),
            payload: any(named: 'payload'),
          )).thenAnswer((_) async {});

      await repository.salvarPonto(ponto);

      verify(() => mockLocal.inserir(any())).called(1);
      verify(() => mockSyncQueue.adicionar(
            entidade: 'ponto_rastreamento',
            operacao: 'create',
            payload: any(named: 'payload'),
          )).called(1);
    });

    test('obterPontosPorAtendimento retorna lista de entidades', () async {
      when(() => mockLocal.listarPorAtendimento('at-1'))
          .thenAnswer((_) async => [model]);

      final result = await repository.obterPontosPorAtendimento('at-1');

      expect(result, hasLength(1));
      expect(result.first.id, 'p-1');
      expect(result.first.latitude, -23.55);
    });

    test('obterNaoSincronizados retorna pontos não sincronizados', () async {
      when(() => mockLocal.listarNaoSincronizados())
          .thenAnswer((_) async => [model]);

      final result = await repository.obterNaoSincronizados();

      expect(result, hasLength(1));
      expect(result.first.synced, false);
    });

    test('marcarComoSincronizados delega para o local datasource', () async {
      when(() => mockLocal.marcarComoSincronizados(['p-1']))
          .thenAnswer((_) async {});

      await repository.marcarComoSincronizados(['p-1']);

      verify(() => mockLocal.marcarComoSincronizados(['p-1'])).called(1);
    });
  });
}

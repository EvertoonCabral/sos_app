import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/entities/local_geo.dart';
import 'package:sos_app/core/sync/sync_queue_datasource.dart';
import 'package:sos_app/features/atendimento/data/datasources/atendimento_local_datasource.dart';
import 'package:sos_app/features/atendimento/data/models/atendimento_model.dart';
import 'package:sos_app/features/atendimento/data/repositories/atendimento_repository_impl.dart';
import 'package:sos_app/features/atendimento/domain/entities/atendimento.dart';
import 'package:sos_app/features/atendimento/domain/entities/atendimento_enums.dart';

class MockLocalDatasource extends Mock implements AtendimentoLocalDatasource {}

class MockSyncQueue extends Mock implements SyncQueueDatasource {}

void main() {
  late AtendimentoRepositoryImpl repository;
  late MockLocalDatasource mockLocal;
  late MockSyncQueue mockSyncQueue;

  const local = LocalGeo(
    enderecoTexto: 'Rua A',
    latitude: -23.55,
    longitude: -46.63,
  );

  final atendimento = Atendimento(
    id: 'at-1',
    clienteId: 'c1',
    usuarioId: 'u1',
    pontoDeSaida: local,
    localDeColeta: local,
    localDeEntrega: local,
    localDeRetorno: local,
    distanciaEstimadaKm: 25.0,
    valorPorKm: 5.0,
    tipoValor: TipoValor.porKm,
    criadoEm: DateTime(2024),
    atualizadoEm: DateTime(2024),
  );

  setUp(() {
    mockLocal = MockLocalDatasource();
    mockSyncQueue = MockSyncQueue();
    repository = AtendimentoRepositoryImpl(
      localDatasource: mockLocal,
      syncQueue: mockSyncQueue,
    );

    registerFallbackValue(AtendimentoModel.fromEntity(atendimento));
  });

  group('AtendimentoRepositoryImpl', () {
    test('criar insere no local e adiciona à sync queue', () async {
      when(() => mockLocal.inserir(any())).thenAnswer((_) async {});
      when(() => mockSyncQueue.adicionar(
            entidade: any(named: 'entidade'),
            operacao: any(named: 'operacao'),
            payload: any(named: 'payload'),
          )).thenAnswer((_) async {});

      final result = await repository.criar(atendimento);

      expect(result, atendimento);
      verify(() => mockLocal.inserir(any())).called(1);
      verify(() => mockSyncQueue.adicionar(
            entidade: 'atendimento',
            operacao: 'create',
            payload: any(named: 'payload'),
          )).called(1);
    });

    test('listar sem filtro retorna todos', () async {
      final model = AtendimentoModel.fromEntity(atendimento);
      when(() => mockLocal.listarTodos()).thenAnswer((_) async => [model]);

      final result = await repository.listar();

      expect(result, hasLength(1));
      expect(result.first.id, 'at-1');
      verify(() => mockLocal.listarTodos()).called(1);
    });

    test('listar com filtro de status retorna filtrados', () async {
      final model = AtendimentoModel.fromEntity(atendimento);
      when(() => mockLocal.listarPorStatus('rascunho'))
          .thenAnswer((_) async => [model]);

      final result =
          await repository.listar(status: AtendimentoStatus.rascunho);

      expect(result, hasLength(1));
      verify(() => mockLocal.listarPorStatus('rascunho')).called(1);
    });

    test('atualizar grava no local e adiciona à sync queue', () async {
      when(() => mockLocal.atualizar(any())).thenAnswer((_) async {});
      when(() => mockSyncQueue.adicionar(
            entidade: any(named: 'entidade'),
            operacao: any(named: 'operacao'),
            payload: any(named: 'payload'),
          )).thenAnswer((_) async {});

      final updated = atendimento.copyWith(
        status: AtendimentoStatus.emDeslocamento,
      );
      final result = await repository.atualizar(updated);

      expect(result.status, AtendimentoStatus.emDeslocamento);
      verify(() => mockLocal.atualizar(any())).called(1);
      verify(() => mockSyncQueue.adicionar(
            entidade: 'atendimento',
            operacao: 'update',
            payload: any(named: 'payload'),
          )).called(1);
    });

    test('obterPorId retorna atendimento do local datasource', () async {
      final model = AtendimentoModel.fromEntity(atendimento);
      when(() => mockLocal.obterPorId('at-1')).thenAnswer((_) async => model);

      final result = await repository.obterPorId('at-1');

      expect(result.id, 'at-1');
      verify(() => mockLocal.obterPorId('at-1')).called(1);
    });
  });
}

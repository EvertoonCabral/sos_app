import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/constants/app_constants.dart';
import 'package:sos_app/core/database/app_database.dart';
import 'package:sos_app/core/network/network_info.dart';
import 'package:sos_app/core/sync/sync_manager.dart';
import 'package:sos_app/core/sync/sync_queue_datasource.dart';

class MockSyncQueue extends Mock implements SyncQueueDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockDio extends Mock implements Dio {}

void main() {
  late SyncManager syncManager;
  late MockSyncQueue mockSyncQueue;
  late MockNetworkInfo mockNetworkInfo;
  late MockDio mockDio;

  final clientePayload = {'id': 'c1', 'nome': 'João', 'telefone': '11999'};
  final atendimentoPayload = {'id': 'at-1', 'clienteId': 'c1'};
  final pontoPayload = {
    'id': 'p-1',
    'atendimentoId': 'at-1',
    'latitude': -23.55,
    'longitude': -46.63,
  };

  SyncQueueEntry makeEntry({
    String id = 'sq-1',
    String entidade = 'cliente',
    String operacao = 'create',
    Map<String, dynamic>? payload,
    int tentativas = 0,
    DateTime? criadoEm,
    DateTime? proximaTentativaEm,
  }) {
    return SyncQueueEntry(
      id: id,
      entidade: entidade,
      operacao: operacao,
      payload: jsonEncode(payload ?? clientePayload),
      tentativas: tentativas,
      criadoEm: criadoEm ?? DateTime(2024),
      proximaTentativaEm: proximaTentativaEm,
    );
  }

  setUp(() {
    mockSyncQueue = MockSyncQueue();
    mockNetworkInfo = MockNetworkInfo();
    mockDio = MockDio();

    syncManager = SyncManager(
      syncQueue: mockSyncQueue,
      networkInfo: mockNetworkInfo,
      dio: mockDio,
    );

    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(Duration.zero);
  });

  tearDown(() => syncManager.dispose());

  group('SyncManager', () {
    group('processar', () {
      test('não processa se não há conexão', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        final result = await syncManager.processar();

        expect(result, 0);
        verifyNever(() =>
            mockSyncQueue.obterPendentes(maxRetries: any(named: 'maxRetries')));
      });

      test('retorna 0 se já está processando', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockSyncQueue.obterPendentes(maxRetries: syncMaxRetries))
            .thenAnswer((_) async {
          // Simula processamento lento
          await Future<void>.delayed(const Duration(milliseconds: 100));
          return [];
        });
        when(() => mockSyncQueue.contarPendentes()).thenAnswer((_) async => 0);
        when(() => mockSyncQueue.contarComErro(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => 0);

        // Inicia primeiro processamento
        final future1 = syncManager.processar();
        // Tenta segundo enquanto o primeiro está em andamento
        final result2 = await syncManager.processar();
        await future1;

        expect(result2, 0);
      });

      test('processa fila vazia sem erros', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockSyncQueue.obterPendentes(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => []);
        when(() => mockSyncQueue.contarPendentes()).thenAnswer((_) async => 0);
        when(() => mockSyncQueue.contarComErro(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => 0);

        final result = await syncManager.processar();

        expect(result, 0);
      });

      test('sincroniza cliente create com sucesso', () async {
        final entry = makeEntry(
          entidade: 'cliente',
          operacao: 'create',
          payload: clientePayload,
        );

        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockSyncQueue.obterPendentes(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => [entry]);
        when(() => mockDio.post('/clientes', data: clientePayload))
            .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(path: '/clientes'),
                  statusCode: 201,
                ));
        when(() => mockSyncQueue.remover('sq-1')).thenAnswer((_) async {});
        when(() => mockSyncQueue.contarPendentes()).thenAnswer((_) async => 0);
        when(() => mockSyncQueue.contarComErro(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => 0);

        final result = await syncManager.processar();

        expect(result, 1);
        verify(() => mockDio.post('/clientes', data: clientePayload)).called(1);
        verify(() => mockSyncQueue.remover('sq-1')).called(1);
      });

      test('sincroniza cliente update com sucesso (last-write-wins)', () async {
        final entry = makeEntry(
          entidade: 'cliente',
          operacao: 'update',
          payload: clientePayload,
        );

        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockSyncQueue.obterPendentes(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => [entry]);
        when(() => mockDio.put('/clientes/c1', data: clientePayload))
            .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(path: '/clientes/c1'),
                  statusCode: 200,
                ));
        when(() => mockSyncQueue.remover('sq-1')).thenAnswer((_) async {});
        when(() => mockSyncQueue.contarPendentes()).thenAnswer((_) async => 0);
        when(() => mockSyncQueue.contarComErro(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => 0);

        final result = await syncManager.processar();

        expect(result, 1);
        verify(() => mockDio.put('/clientes/c1', data: clientePayload))
            .called(1);
      });

      test('sincroniza atendimento create com sucesso', () async {
        final entry = makeEntry(
          id: 'sq-2',
          entidade: 'atendimento',
          operacao: 'create',
          payload: atendimentoPayload,
        );

        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockSyncQueue.obterPendentes(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => [entry]);
        when(() => mockDio.post('/atendimentos', data: atendimentoPayload))
            .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(path: '/atendimentos'),
                  statusCode: 201,
                ));
        when(() => mockSyncQueue.remover('sq-2')).thenAnswer((_) async {});
        when(() => mockSyncQueue.contarPendentes()).thenAnswer((_) async => 0);
        when(() => mockSyncQueue.contarComErro(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => 0);

        final result = await syncManager.processar();

        expect(result, 1);
        verify(() => mockDio.post('/atendimentos', data: atendimentoPayload))
            .called(1);
      });

      test('sincroniza ponto_rastreamento create com sucesso', () async {
        final entry = makeEntry(
          id: 'sq-3',
          entidade: 'ponto_rastreamento',
          operacao: 'create',
          payload: pontoPayload,
        );

        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockSyncQueue.obterPendentes(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => [entry]);
        when(() => mockDio.post('/pontos-rastreamento', data: pontoPayload))
            .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(path: '/pontos-rastreamento'),
                  statusCode: 201,
                ));
        when(() => mockSyncQueue.remover('sq-3')).thenAnswer((_) async {});
        when(() => mockSyncQueue.contarPendentes()).thenAnswer((_) async => 0);
        when(() => mockSyncQueue.contarComErro(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => 0);

        final result = await syncManager.processar();

        expect(result, 1);
      });

      test('incrementa tentativas na falha de API', () async {
        final entry = makeEntry(tentativas: 0);

        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockSyncQueue.obterPendentes(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => [entry]);
        when(() => mockDio.post('/clientes', data: clientePayload))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/clientes'),
          type: DioExceptionType.connectionError,
        ));
        when(() => mockSyncQueue.incrementarTentativas(
              'sq-1',
              backoff: any(named: 'backoff'),
            )).thenAnswer((_) async {});
        when(() => mockSyncQueue.contarPendentes()).thenAnswer((_) async => 1);
        when(() => mockSyncQueue.contarComErro(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => 0);

        final result = await syncManager.processar();

        expect(result, 0);
        verify(() => mockSyncQueue.incrementarTentativas(
              'sq-1',
              backoff: any(named: 'backoff'),
            )).called(1);
        verifyNever(() => mockSyncQueue.remover('sq-1'));
      });

      test('processa múltiplos itens e conta apenas os sucedidos', () async {
        final entry1 = makeEntry(id: 'sq-1', payload: clientePayload);
        final entry2 = makeEntry(
          id: 'sq-2',
          entidade: 'atendimento',
          operacao: 'create',
          payload: atendimentoPayload,
        );

        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockSyncQueue.obterPendentes(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => [entry1, entry2]);
        when(() => mockDio.post('/clientes', data: clientePayload))
            .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(path: '/clientes'),
                  statusCode: 201,
                ));
        when(() => mockDio.post('/atendimentos', data: atendimentoPayload))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/atendimentos'),
          type: DioExceptionType.connectionError,
        ));
        when(() => mockSyncQueue.remover('sq-1')).thenAnswer((_) async {});
        when(() => mockSyncQueue.incrementarTentativas(
              'sq-2',
              backoff: any(named: 'backoff'),
            )).thenAnswer((_) async {});
        when(() => mockSyncQueue.contarPendentes()).thenAnswer((_) async => 1);
        when(() => mockSyncQueue.contarComErro(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => 0);

        final result = await syncManager.processar();

        expect(result, 1);
        verify(() => mockSyncQueue.remover('sq-1')).called(1);
        verify(() => mockSyncQueue.incrementarTentativas(
              'sq-2',
              backoff: any(named: 'backoff'),
            )).called(1);
      });
    });

    group('backoff exponencial', () {
      test('primeira falha: backoff = 1s', () async {
        final entry = makeEntry(tentativas: 0);

        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockSyncQueue.obterPendentes(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => [entry]);
        when(() => mockDio.post('/clientes', data: clientePayload))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/clientes'),
          type: DioExceptionType.connectionError,
        ));
        when(() => mockSyncQueue.incrementarTentativas(
              'sq-1',
              backoff: const Duration(seconds: 1),
            )).thenAnswer((_) async {});
        when(() => mockSyncQueue.contarPendentes()).thenAnswer((_) async => 1);
        when(() => mockSyncQueue.contarComErro(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => 0);

        await syncManager.processar();

        verify(() => mockSyncQueue.incrementarTentativas(
              'sq-1',
              backoff: const Duration(seconds: 1),
            )).called(1);
      });

      test('segunda falha: backoff = 2s', () async {
        final entry = makeEntry(tentativas: 1);

        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockSyncQueue.obterPendentes(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => [entry]);
        when(() => mockDio.post('/clientes', data: clientePayload))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/clientes'),
          type: DioExceptionType.connectionError,
        ));
        when(() => mockSyncQueue.incrementarTentativas(
              'sq-1',
              backoff: const Duration(seconds: 2),
            )).thenAnswer((_) async {});
        when(() => mockSyncQueue.contarPendentes()).thenAnswer((_) async => 1);
        when(() => mockSyncQueue.contarComErro(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => 0);

        await syncManager.processar();

        verify(() => mockSyncQueue.incrementarTentativas(
              'sq-1',
              backoff: const Duration(seconds: 2),
            )).called(1);
      });

      test('terceira falha: backoff = 4s', () async {
        final entry = makeEntry(tentativas: 2);

        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockSyncQueue.obterPendentes(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => [entry]);
        when(() => mockDio.post('/clientes', data: clientePayload))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/clientes'),
          type: DioExceptionType.connectionError,
        ));
        when(() => mockSyncQueue.incrementarTentativas(
              'sq-1',
              backoff: const Duration(seconds: 4),
            )).thenAnswer((_) async {});
        when(() => mockSyncQueue.contarPendentes()).thenAnswer((_) async => 1);
        when(() => mockSyncQueue.contarComErro(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => 0);

        await syncManager.processar();

        verify(() => mockSyncQueue.incrementarTentativas(
              'sq-1',
              backoff: const Duration(seconds: 4),
            )).called(1);
      });

      test('backoff com cap em 60s', () async {
        final entry = makeEntry(tentativas: 10); // 2^10 = 1024 > 60

        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockSyncQueue.obterPendentes(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => [entry]);
        when(() => mockDio.post('/clientes', data: clientePayload))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/clientes'),
          type: DioExceptionType.connectionError,
        ));
        when(() => mockSyncQueue.incrementarTentativas(
              'sq-1',
              backoff: const Duration(seconds: 60),
            )).thenAnswer((_) async {});
        when(() => mockSyncQueue.contarPendentes()).thenAnswer((_) async => 1);
        when(() => mockSyncQueue.contarComErro(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => 0);

        await syncManager.processar();

        verify(() => mockSyncQueue.incrementarTentativas(
              'sq-1',
              backoff: const Duration(seconds: 60),
            )).called(1);
      });
    });

    group('obterStatus', () {
      test('retorna sincronizado quando fila vazia', () async {
        when(() => mockSyncQueue.contarPendentes()).thenAnswer((_) async => 0);

        final status = await syncManager.obterStatus();

        expect(status, SyncStatus.sincronizado);
      });

      test('retorna pendente quando há itens na fila', () async {
        when(() => mockSyncQueue.contarPendentes()).thenAnswer((_) async => 3);
        when(() => mockSyncQueue.contarComErro(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => 0);

        final status = await syncManager.obterStatus();

        expect(status, SyncStatus.pendente);
      });

      test('retorna erro quando todos itens esgotaram tentativas', () async {
        when(() => mockSyncQueue.contarPendentes()).thenAnswer((_) async => 2);
        when(() => mockSyncQueue.contarComErro(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => 2);

        final status = await syncManager.obterStatus();

        expect(status, SyncStatus.erro);
      });

      test('retorna pendente quando mix de erros e pendentes', () async {
        when(() => mockSyncQueue.contarPendentes()).thenAnswer((_) async => 3);
        when(() => mockSyncQueue.contarComErro(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => 1);

        final status = await syncManager.obterStatus();

        expect(status, SyncStatus.pendente);
      });
    });

    group('statusStream', () {
      test('emite sincronizando durante processamento e status final',
          () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockSyncQueue.obterPendentes(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => []);
        when(() => mockSyncQueue.contarPendentes()).thenAnswer((_) async => 0);
        when(() => mockSyncQueue.contarComErro(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => 0);

        final statuses = <SyncStatus>[];
        final sub = syncManager.statusStream.listen(statuses.add);

        await syncManager.processar();
        await Future<void>.delayed(Duration.zero);

        expect(statuses, contains(SyncStatus.sincronizando));
        expect(statuses.last, SyncStatus.sincronizado);

        await sub.cancel();
      });
    });

    group('iniciarMonitoramento', () {
      test('processa ao detectar conexão', () async {
        final connectivityController = StreamController<bool>();

        when(() => mockNetworkInfo.onConnectivityChanged)
            .thenAnswer((_) => connectivityController.stream);
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockSyncQueue.obterPendentes(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => []);
        when(() => mockSyncQueue.contarPendentes()).thenAnswer((_) async => 0);
        when(() => mockSyncQueue.contarComErro(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => 0);

        syncManager.iniciarMonitoramento();
        connectivityController.add(true);

        // Give time for the listener to fire
        await Future<void>.delayed(const Duration(milliseconds: 50));

        verify(() => mockSyncQueue.obterPendentes(maxRetries: syncMaxRetries))
            .called(1);

        await connectivityController.close();
      });

      test('não processa quando desconectado', () async {
        final connectivityController = StreamController<bool>();

        when(() => mockNetworkInfo.onConnectivityChanged)
            .thenAnswer((_) => connectivityController.stream);

        syncManager.iniciarMonitoramento();
        connectivityController.add(false);

        await Future<void>.delayed(const Duration(milliseconds: 50));

        verifyNever(() =>
            mockSyncQueue.obterPendentes(maxRetries: any(named: 'maxRetries')));

        await connectivityController.close();
      });
    });

    group('entidades desconhecidas', () {
      test('incrementa tentativas para entidade desconhecida', () async {
        final entry = makeEntry(
          entidade: 'desconhecida',
          operacao: 'create',
        );

        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockSyncQueue.obterPendentes(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => [entry]);
        when(() => mockSyncQueue.incrementarTentativas(
              'sq-1',
              backoff: any(named: 'backoff'),
            )).thenAnswer((_) async {});
        when(() => mockSyncQueue.contarPendentes()).thenAnswer((_) async => 1);
        when(() => mockSyncQueue.contarComErro(maxRetries: syncMaxRetries))
            .thenAnswer((_) async => 0);

        final result = await syncManager.processar();

        expect(result, 0);
        verify(() => mockSyncQueue.incrementarTentativas(
              'sq-1',
              backoff: any(named: 'backoff'),
            )).called(1);
      });
    });
  });
}

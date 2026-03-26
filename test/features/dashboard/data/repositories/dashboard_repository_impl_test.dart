import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/error/exceptions.dart';
import 'package:sos_app/features/dashboard/data/models/atendimentos_por_dia_model.dart';
import 'package:sos_app/features/dashboard/data/models/resumo_cliente_model.dart';
import 'package:sos_app/features/dashboard/data/models/resumo_periodo_model.dart';
import 'package:sos_app/features/dashboard/data/models/tempo_por_etapa_model.dart';
import 'package:sos_app/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:sos_app/features/dashboard/domain/entities/resumo_cliente.dart';
import 'package:sos_app/features/dashboard/domain/entities/resumo_periodo.dart';
import 'package:sos_app/features/dashboard/domain/entities/tempo_por_etapa.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late DashboardRepositoryImpl repository;
  late MockDashboardLocalDatasource mockLocalDatasource;
  late MockDashboardRemoteDatasource mockRemoteDatasource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDatasource = MockDashboardLocalDatasource();
    mockRemoteDatasource = MockDashboardRemoteDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = DashboardRepositoryImpl(
      localDatasource: mockLocalDatasource,
      remoteDatasource: mockRemoteDatasource,
      networkInfo: mockNetworkInfo,
    );
  });

  final inicio = DateTime(2026, 3, 1);
  final fim = DateTime(2026, 3, 31);

  group('obterResumoPeriodo', () {
    test('deve usar remote quando online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.obterResumoPeriodo(
            inicio: inicio,
            fim: fim,
          )).thenAnswer(
        (_) async => const ResumoPeriodoModel(
          kmOperacional: 150,
          kmCobrado: 120,
          receitaTotal: 700,
          totalAtendimentos: 12,
          totalConcluidos: 9,
          totalCancelados: 1,
          totalEmAndamento: 2,
        ),
      );

      final result = await repository.obterResumoPeriodo(
        inicio: inicio,
        fim: fim,
      );

      expect(result.kmOperacional, 150);
      verifyNever(() => mockLocalDatasource.obterResumoPeriodo(
            inicio: any(named: 'inicio'),
            fim: any(named: 'fim'),
          ));
    });

    test('deve mapear dados do datasource para ResumoPeriodo', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.obterResumoPeriodo(
            inicio: inicio,
            fim: fim,
          )).thenAnswer((_) async => {
            'kmOperacional': 100.0,
            'kmCobrado': 100.0,
            'receitaTotal': 500.0,
            'totalAtendimentos': 10,
            'totalConcluidos': 8,
            'totalCancelados': 1,
            'totalEmAndamento': 1,
          });

      final result = await repository.obterResumoPeriodo(
        inicio: inicio,
        fim: fim,
      );

      expect(result, isA<ResumoPeriodo>());
      expect(result.kmOperacional, 100.0);
      expect(result.receitaTotal, 500.0);
      expect(result.totalConcluidos, 8);
    });
  });

  group('obterKmPorCliente', () {
    test('deve mapear lista de maps para ResumoCliente', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.obterKmPorCliente(
            inicio: inicio,
            fim: fim,
          )).thenAnswer((_) async => [
            {
              'clienteId': 'c1',
              'clienteNome': 'João',
              'totalAtendimentos': 5,
              'totalKm': 200.0,
              'totalReceita': 1000.0,
            },
          ]);

      final result = await repository.obterKmPorCliente(
        inicio: inicio,
        fim: fim,
      );

      expect(result, hasLength(1));
      expect(result.first, isA<ResumoCliente>());
      expect(result.first.clienteNome, 'João');
      expect(result.first.totalKm, 200.0);
    });

    test('deve retornar lista vazia', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.obterKmPorCliente(
            inicio: inicio,
            fim: fim,
          )).thenAnswer((_) async => []);

      final result = await repository.obterKmPorCliente(
        inicio: inicio,
        fim: fim,
      );

      expect(result, isEmpty);
    });
  });

  group('obterTempoPorEtapa', () {
    test('deve cair para local quando remote falha', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.obterTempoPorEtapa(
            inicio: inicio,
            fim: fim,
          )).thenThrow(
        const ServerException(message: 'erro', statusCode: 500),
      );
      when(() => mockLocalDatasource.obterTempoPorEtapa(
            inicio: inicio,
            fim: fim,
          )).thenAnswer((_) async => {
            'mediaMinutosAteColeta': 20.0,
            'mediaMinutosColetaEntrega': 30.0,
            'mediaMinutosEntregaRetorno': 5.0,
            'mediaMinutosRetornoBase': 15.0,
            'totalAnalisados': 10,
          });

      final result = await repository.obterTempoPorEtapa(
        inicio: inicio,
        fim: fim,
      );

      expect(result.totalAnalisados, 10);
    });

    test('deve mapear dados para TempoPorEtapa', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.obterTempoPorEtapa(
            inicio: inicio,
            fim: fim,
          )).thenAnswer((_) async => {
            'mediaMinutosAteColeta': 20.0,
            'mediaMinutosColetaEntrega': 30.0,
            'mediaMinutosEntregaRetorno': 5.0,
            'mediaMinutosRetornoBase': 15.0,
            'totalAnalisados': 10,
          });

      final result = await repository.obterTempoPorEtapa(
        inicio: inicio,
        fim: fim,
      );

      expect(result, isA<TempoPorEtapa>());
      expect(result.mediaMinutosAteColeta, 20.0);
      expect(result.totalAnalisados, 10);
    });
  });

  group('obterAtendimentosPorDia', () {
    test('deve mapear remote para Map<DateTime, int>', () async {
      final dia1 = DateTime.utc(2026, 3, 10, 12);
      final dia2 = DateTime.utc(2026, 3, 11, 12);
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.obterAtendimentosPorDia(
            inicio: inicio,
            fim: fim,
          )).thenAnswer((_) async => [
            AtendimentosPorDiaModel(data: dia1, quantidade: 3),
            AtendimentosPorDiaModel(data: dia2, quantidade: 5),
          ]);

      final result = await repository.obterAtendimentosPorDia(
        inicio: inicio,
        fim: fim,
      );

      expect(result, {
        DateTime(2026, 3, 10): 3,
        DateTime(2026, 3, 11): 5,
      });
    });

    test('deve delegar ao datasource e retornar map', () async {
      final dia1 = DateTime(2026, 3, 10);
      final dia2 = DateTime(2026, 3, 11);

      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.obterAtendimentosPorDia(
            inicio: inicio,
            fim: fim,
          )).thenAnswer((_) async => {dia1: 3, dia2: 5});

      final result = await repository.obterAtendimentosPorDia(
        inicio: inicio,
        fim: fim,
      );

      expect(result, {dia1: 3, dia2: 5});
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:sos_app/features/dashboard/domain/entities/resumo_cliente.dart';
import 'package:sos_app/features/dashboard/domain/entities/resumo_periodo.dart';
import 'package:sos_app/features/dashboard/domain/entities/tempo_por_etapa.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late DashboardRepositoryImpl repository;
  late MockDashboardLocalDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockDashboardLocalDatasource();
    repository = DashboardRepositoryImpl(localDatasource: mockDatasource);
  });

  final inicio = DateTime(2026, 3, 1);
  final fim = DateTime(2026, 3, 31);

  group('obterResumoPeriodo', () {
    test('deve mapear dados do datasource para ResumoPeriodo', () async {
      when(() => mockDatasource.obterResumoPeriodo(
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
      when(() => mockDatasource.obterKmPorCliente(
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
      when(() => mockDatasource.obterKmPorCliente(
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
    test('deve mapear dados para TempoPorEtapa', () async {
      when(() => mockDatasource.obterTempoPorEtapa(
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
    test('deve delegar ao datasource e retornar map', () async {
      final dia1 = DateTime(2026, 3, 10);
      final dia2 = DateTime(2026, 3, 11);

      when(() => mockDatasource.obterAtendimentosPorDia(
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

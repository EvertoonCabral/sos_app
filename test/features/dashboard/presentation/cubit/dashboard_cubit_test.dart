import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/features/dashboard/domain/entities/resumo_cliente.dart';
import 'package:sos_app/features/dashboard/domain/entities/resumo_periodo.dart';
import 'package:sos_app/features/dashboard/domain/entities/tempo_por_etapa.dart';
import 'package:sos_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:sos_app/features/dashboard/presentation/cubit/dashboard_state.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late DashboardCubit cubit;
  late MockObterResumoPeriodo mockObterResumoPeriodo;
  late MockObterKmPorCliente mockObterKmPorCliente;
  late MockObterTempoPorEtapa mockObterTempoPorEtapa;
  late MockDashboardRepository mockRepository;

  final inicio = DateTime(2026, 3, 1);
  final fim = DateTime(2026, 3, 31, 23, 59, 59);

  const resumo = ResumoPeriodo(
    kmOperacional: 200.0,
    kmCobrado: 200.0,
    receitaTotal: 1000.0,
    totalAtendimentos: 15,
    totalConcluidos: 12,
    totalCancelados: 1,
    totalEmAndamento: 2,
  );

  final ranking = [
    const ResumoCliente(
      clienteId: 'c1',
      clienteNome: 'João',
      totalAtendimentos: 5,
      totalKm: 100.0,
      totalReceita: 500.0,
    ),
  ];

  const tempos = TempoPorEtapa(
    mediaMinutosAteColeta: 20.0,
    mediaMinutosColetaEntrega: 30.0,
    mediaMinutosEntregaRetorno: 5.0,
    mediaMinutosRetornoBase: 15.0,
    totalAnalisados: 10,
  );

  final atendimentosPorDia = {
    DateTime(2026, 3, 10): 3,
    DateTime(2026, 3, 11): 5,
  };

  setUp(() {
    mockObterResumoPeriodo = MockObterResumoPeriodo();
    mockObterKmPorCliente = MockObterKmPorCliente();
    mockObterTempoPorEtapa = MockObterTempoPorEtapa();
    mockRepository = MockDashboardRepository();

    cubit = DashboardCubit(
      obterResumoPeriodo: mockObterResumoPeriodo,
      obterKmPorCliente: mockObterKmPorCliente,
      obterTempoPorEtapa: mockObterTempoPorEtapa,
      dashboardRepository: mockRepository,
    );
  });

  tearDown(() => cubit.close());

  test('estado inicial é DashboardInicial', () {
    expect(cubit.state, const DashboardInicial());
  });

  group('carregarDashboard', () {
    void setUpSuccess() {
      when(() => mockObterResumoPeriodo(
            inicio: any(named: 'inicio'),
            fim: any(named: 'fim'),
          )).thenAnswer((_) async => resumo);

      when(() => mockObterKmPorCliente(
            inicio: any(named: 'inicio'),
            fim: any(named: 'fim'),
          )).thenAnswer((_) async => ranking);

      when(() => mockObterTempoPorEtapa(
            inicio: any(named: 'inicio'),
            fim: any(named: 'fim'),
          )).thenAnswer((_) async => tempos);

      when(() => mockRepository.obterAtendimentosPorDia(
            inicio: any(named: 'inicio'),
            fim: any(named: 'fim'),
          )).thenAnswer((_) async => atendimentosPorDia);
    }

    blocTest<DashboardCubit, DashboardState>(
      'emite [carregando, carregado] quando sucesso',
      build: () {
        setUpSuccess();
        return cubit;
      },
      act: (c) => c.carregarDashboard(inicio: inicio, fim: fim),
      expect: () => [
        const DashboardCarregando(),
        isA<DashboardCarregado>()
            .having((s) => s.resumo, 'resumo', resumo)
            .having((s) => s.rankingClientes, 'ranking', ranking)
            .having((s) => s.tempoPorEtapa, 'tempos', tempos)
            .having((s) => s.atendimentosPorDia, 'porDia', atendimentosPorDia),
      ],
    );

    blocTest<DashboardCubit, DashboardState>(
      'emite [carregando, erro] quando usecase lança exceção',
      build: () {
        when(() => mockObterResumoPeriodo(
              inicio: any(named: 'inicio'),
              fim: any(named: 'fim'),
            )).thenThrow(Exception('Erro no banco'));

        when(() => mockObterKmPorCliente(
              inicio: any(named: 'inicio'),
              fim: any(named: 'fim'),
            )).thenAnswer((_) async => ranking);

        when(() => mockObterTempoPorEtapa(
              inicio: any(named: 'inicio'),
              fim: any(named: 'fim'),
            )).thenAnswer((_) async => tempos);

        when(() => mockRepository.obterAtendimentosPorDia(
              inicio: any(named: 'inicio'),
              fim: any(named: 'fim'),
            )).thenAnswer((_) async => atendimentosPorDia);

        return cubit;
      },
      act: (c) => c.carregarDashboard(inicio: inicio, fim: fim),
      expect: () => [
        const DashboardCarregando(),
        isA<DashboardErro>(),
      ],
    );

    blocTest<DashboardCubit, DashboardState>(
      'chama todos os usecases com datas corretas',
      build: () {
        setUpSuccess();
        return cubit;
      },
      act: (c) => c.carregarDashboard(inicio: inicio, fim: fim),
      verify: (_) {
        verify(() => mockObterResumoPeriodo(
              inicio: inicio,
              fim: fim,
            )).called(1);
        verify(() => mockObterKmPorCliente(
              inicio: inicio,
              fim: fim,
            )).called(1);
        verify(() => mockObterTempoPorEtapa(
              inicio: inicio,
              fim: fim,
            )).called(1);
        verify(() => mockRepository.obterAtendimentosPorDia(
              inicio: inicio,
              fim: fim,
            )).called(1);
      },
    );

    blocTest<DashboardCubit, DashboardState>(
      'carregado contém datas do período',
      build: () {
        setUpSuccess();
        return cubit;
      },
      act: (c) => c.carregarDashboard(inicio: inicio, fim: fim),
      expect: () => [
        const DashboardCarregando(),
        isA<DashboardCarregado>()
            .having((s) => s.inicio, 'inicio', inicio)
            .having((s) => s.fim, 'fim', fim),
      ],
    );
  });
}

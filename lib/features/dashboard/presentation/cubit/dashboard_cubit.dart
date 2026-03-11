import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/obter_km_por_cliente.dart';
import '../../domain/usecases/obter_resumo_periodo.dart';
import '../../domain/usecases/obter_tempo_por_etapa.dart';
import '../../domain/repositories/dashboard_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({
    required ObterResumoPeriodo obterResumoPeriodo,
    required ObterKmPorCliente obterKmPorCliente,
    required ObterTempoPorEtapa obterTempoPorEtapa,
    required DashboardRepository dashboardRepository,
  })  : _obterResumoPeriodo = obterResumoPeriodo,
        _obterKmPorCliente = obterKmPorCliente,
        _obterTempoPorEtapa = obterTempoPorEtapa,
        _dashboardRepository = dashboardRepository,
        super(const DashboardInicial());

  final ObterResumoPeriodo _obterResumoPeriodo;
  final ObterKmPorCliente _obterKmPorCliente;
  final ObterTempoPorEtapa _obterTempoPorEtapa;
  final DashboardRepository _dashboardRepository;

  Future<void> carregarDashboard({
    required DateTime inicio,
    required DateTime fim,
  }) async {
    emit(const DashboardCarregando());

    try {
      final results = await Future.wait([
        _obterResumoPeriodo(inicio: inicio, fim: fim),
        _obterKmPorCliente(inicio: inicio, fim: fim),
        _obterTempoPorEtapa(inicio: inicio, fim: fim),
        _dashboardRepository.obterAtendimentosPorDia(
          inicio: inicio,
          fim: fim,
        ),
      ]);

      emit(DashboardCarregado(
        resumo: results[0] as dynamic,
        rankingClientes: results[1] as dynamic,
        tempoPorEtapa: results[2] as dynamic,
        atendimentosPorDia: results[3] as dynamic,
        inicio: inicio,
        fim: fim,
      ));
    } on Failure catch (f) {
      emit(DashboardErro(f.message));
    } catch (e) {
      emit(DashboardErro(e.toString()));
    }
  }

  /// Atalho para carregar o dia atual.
  Future<void> carregarHoje() async {
    final agora = DateTime.now();
    final inicio = DateTime(agora.year, agora.month, agora.day);
    final fim = inicio.add(const Duration(days: 1)).subtract(
          const Duration(milliseconds: 1),
        );
    await carregarDashboard(inicio: inicio, fim: fim);
  }

  /// Atalho para carregar a semana atual.
  Future<void> carregarSemana() async {
    final agora = DateTime.now();
    final inicio = DateTime(agora.year, agora.month, agora.day)
        .subtract(Duration(days: agora.weekday - 1));
    final fim = inicio
        .add(const Duration(days: 7))
        .subtract(const Duration(milliseconds: 1));
    await carregarDashboard(inicio: inicio, fim: fim);
  }

  /// Atalho para carregar o mês atual.
  Future<void> carregarMes() async {
    final agora = DateTime.now();
    final inicio = DateTime(agora.year, agora.month);
    final fim = DateTime(agora.year, agora.month + 1)
        .subtract(const Duration(milliseconds: 1));
    await carregarDashboard(inicio: inicio, fim: fim);
  }
}

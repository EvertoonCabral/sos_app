import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/grafico_atendimentos_widget.dart';
import '../widgets/metricas_cards_widget.dart';
import '../widgets/ranking_clientes_widget.dart';
import '../widgets/seletor_periodo_widget.dart';
import '../widgets/tempo_por_etapa_widget.dart';

/// Página principal do dashboard (S7-05).
/// RN-038: métricas de produtividade calculadas do banco local.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Carrega mês atual por padrão
    context.read<DashboardCubit>().carregarMes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Column(
        children: [
          // Gradient header with period selector
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primaryContainer,
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: SeletorPeriodoWidget(
              onPeriodoSelecionado: (tipo, inicio, fim) {
                context.read<DashboardCubit>().carregarDashboard(
                      inicio: inicio,
                      fim: fim,
                    );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                if (state is DashboardCarregando) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is DashboardErro) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(state.mensagem),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<DashboardCubit>().carregarMes(),
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is DashboardCarregado) {
                  return RefreshIndicator(
                    onRefresh: () =>
                        context.read<DashboardCubit>().carregarDashboard(
                              inicio: state.inicio,
                              fim: state.fim,
                            ),
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        MetricasCardsWidget(resumo: state.resumo),
                        const SizedBox(height: 16),
                        GraficoAtendimentosWidget(
                          atendimentosPorDia: state.atendimentosPorDia,
                        ),
                        const SizedBox(height: 16),
                        TempoPorEtapaWidget(
                          tempoPorEtapa: state.tempoPorEtapa,
                        ),
                        const SizedBox(height: 16),
                        RankingClientesWidget(
                          ranking: state.rankingClientes,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

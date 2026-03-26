import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../atendimento/domain/usecases/atualizar_status_atendimento.dart';
import '../../../atendimento/domain/usecases/criar_atendimento.dart';
import '../../../atendimento/domain/usecases/listar_atendimentos.dart';
import '../../../atendimento/presentation/bloc/atendimento_bloc.dart';
import '../../../atendimento/presentation/pages/lista_atendimentos_page.dart';
import '../../../rastreamento/domain/usecases/calcular_valor_real.dart';
import '../../../rastreamento/domain/usecases/obter_percurso.dart';
import '../../../rastreamento/domain/usecases/registrar_ponto.dart';
import '../../../rastreamento/presentation/bloc/rastreamento_bloc.dart';
import '../../../../core/geo/gps_collector.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../base/domain/usecases/criar_base.dart';
import '../../../base/domain/usecases/definir_base_principal.dart';
import '../../../base/domain/usecases/listar_bases.dart';
import '../../../base/presentation/bloc/base_bloc.dart';
import '../../../base/presentation/pages/gestao_bases_page.dart';
import '../../../cliente/domain/usecases/atualizar_cliente.dart';
import '../../../cliente/domain/usecases/buscar_clientes.dart';
import '../../../cliente/domain/usecases/criar_cliente.dart';
import '../../../cliente/presentation/bloc/cliente_bloc.dart';
import '../../../cliente/presentation/pages/buscar_cliente_page.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/obter_km_por_cliente.dart';
import '../../domain/usecases/obter_resumo_periodo.dart';
import '../../domain/usecases/obter_tempo_por_etapa.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/grafico_atendimentos_widget.dart';
import '../widgets/metricas_cards_widget.dart';
import '../widgets/ranking_clientes_widget.dart';
import '../widgets/seletor_periodo_widget.dart';
import '../widgets/tempo_por_etapa_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final DashboardCubit _dashboardCubit;

  @override
  void initState() {
    super.initState();
    _dashboardCubit = DashboardCubit(
      obterResumoPeriodo: GetIt.I<ObterResumoPeriodo>(),
      obterKmPorCliente: GetIt.I<ObterKmPorCliente>(),
      obterTempoPorEtapa: GetIt.I<ObterTempoPorEtapa>(),
      dashboardRepository: GetIt.I<DashboardRepository>(),
    )..carregarMes();
  }

  @override
  void dispose() {
    _dashboardCubit.close();
    super.dispose();
  }

  Future<void> _confirmarLogout(BuildContext context) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair do app'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Não'),
          ),
          ElevatedButton(
            key: const Key('confirmarLogoutButton'),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sim, sair'),
          ),
        ],
      ),
    );
    if (confirmou == true && context.mounted) {
      context.read<AuthBloc>().add(const LogoutSolicitado());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final nomeUsuario =
        authState is AuthAutenticado ? authState.usuario.nome : 'Usuário';
    final emailUsuario =
        authState is AuthAutenticado ? authState.usuario.email : '';
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _dashboardCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('GuinchoApp'),
              Text(
                'Olá, $nomeUsuario',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              key: const Key('logoutButton'),
              icon: const Icon(Icons.logout),
              onPressed: () => _confirmarLogout(context),
            ),
          ],
        ),
        drawer: Drawer(
          key: const Key('appDrawer'),
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                accountName: Text(
                  nomeUsuario,
                  key: const Key('drawerUserName'),
                ),
                accountEmail: Text(
                  emailUsuario,
                  key: const Key('drawerUserEmail'),
                ),
              ),
              ListTile(
                key: const Key('menuDashboard'),
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                selected: true,
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                key: const Key('menuAtendimentos'),
                leading: const Icon(Icons.local_shipping),
                title: const Text('Atendimentos'),
                onTap: () {
                  Navigator.of(context).pop();
                  _abrirAtendimentos(context);
                },
              ),
              ListTile(
                key: const Key('menuClientes'),
                leading: const Icon(Icons.people),
                title: const Text('Clientes'),
                onTap: () {
                  Navigator.of(context).pop();
                  _abrirClientes(context);
                },
              ),
              ListTile(
                key: const Key('menuBases'),
                leading: const Icon(Icons.warehouse),
                title: const Text('Bases / Garagens'),
                onTap: () {
                  Navigator.of(context).pop();
                  _abrirBases(context);
                },
              ),
              const Spacer(),
              const Divider(),
              ListTile(
                key: const Key('menuLogout'),
                leading: const Icon(Icons.logout),
                title: const Text('Sair'),
                onTap: () {
                  Navigator.of(context).pop();
                  _confirmarLogout(context);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        // Dashboard inline as main content
        body: _DashboardBody(cubit: _dashboardCubit),
      ),
    );
  }

  void _abrirAtendimentos(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AtendimentoBloc(
              criarAtendimento: GetIt.I<CriarAtendimento>(),
              listarAtendimentos: GetIt.I<ListarAtendimentos>(),
              atualizarStatusAtendimento: GetIt.I<AtualizarStatusAtendimento>(),
            ),
          ),
          BlocProvider(
            create: (_) => RastreamentoBloc(
              registrarPonto: GetIt.I<RegistrarPonto>(),
              obterPercurso: GetIt.I<ObterPercurso>(),
              calcularValorReal: GetIt.I<CalcularValorReal>(),
              distanceCalculator: GetIt.I<DistanceCalculator>(),
              gpsCollector: GetIt.I<GpsCollector>(),
            ),
          ),
        ],
        child: const ListaAtendimentosPage(),
      ),
    ));
  }

  void _abrirClientes(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => ClienteBloc(
          criarCliente: GetIt.I<CriarCliente>(),
          buscarClientes: GetIt.I<BuscarClientes>(),
          atualizarCliente: GetIt.I<AtualizarCliente>(),
        ),
        child: const BuscarClientePage(),
      ),
    ));
  }

  void _abrirBases(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => BaseBloc(
          criarBase: GetIt.I<CriarBase>(),
          listarBases: GetIt.I<ListarBases>(),
          definirBasePrincipal: GetIt.I<DefinirBasePrincipal>(),
        ),
        child: const GestaoBasesPage(),
      ),
    ));
  }
}

/// Dashboard content inlined in HomePage.
class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.cubit});

  final DashboardCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
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
              cubit.carregarDashboard(inicio: inicio, fim: fim);
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
                        onPressed: () => cubit.carregarMes(),
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                );
              }

              if (state is DashboardCarregado) {
                return RefreshIndicator(
                  onRefresh: () => cubit.carregarDashboard(
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
    );
  }
}

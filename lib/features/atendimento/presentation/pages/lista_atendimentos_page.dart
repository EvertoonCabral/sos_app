import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/geo/geo_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../base/domain/entities/base.dart';
import '../../../base/domain/usecases/listar_bases.dart';
import '../../../cliente/domain/entities/cliente.dart';
import '../../../cliente/domain/usecases/buscar_clientes.dart';
import '../../domain/entities/atendimento.dart';
import '../../domain/entities/atendimento_enums.dart';
import '../bloc/atendimento_bloc.dart';
import '../bloc/atendimento_event.dart';
import '../bloc/atendimento_state.dart';
import 'detalhe_atendimento_page.dart';
import 'novo_atendimento_page.dart';
import '../../../rastreamento/presentation/bloc/rastreamento_bloc.dart';

class ListaAtendimentosPage extends StatefulWidget {
  const ListaAtendimentosPage({super.key});

  @override
  State<ListaAtendimentosPage> createState() => _ListaAtendimentosPageState();
}

class _ListaAtendimentosPageState extends State<ListaAtendimentosPage> {
  AtendimentoStatus? _filtroStatus;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  void _carregar() {
    context
        .read<AtendimentoBloc>()
        .add(ListarAtendimentosEvent(status: _filtroStatus));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atendimentos'),
        actions: [
          PopupMenuButton<AtendimentoStatus?>(
            key: const Key('filtroStatusButton'),
            icon: const Icon(Icons.filter_list),
            onSelected: (status) {
              setState(() => _filtroStatus = status);
              _carregar();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: null,
                child: Text('Todos'),
              ),
              ...AtendimentoStatus.values.map((s) => PopupMenuItem(
                    value: s,
                    child: Text(_statusLabel(s)),
                  )),
            ],
          ),
        ],
      ),
      body: BlocBuilder<AtendimentoBloc, AtendimentoState>(
        builder: (context, state) {
          if (state is AtendimentoCarregando) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AtendimentoErro) {
            return ErrorStateWidget(
              mensagem: state.mensagem,
              onRetry: _carregar,
            );
          }
          if (state is AtendimentoListaCarregada) {
            if (state.atendimentos.isEmpty) {
              return const EmptyStateWidget(
                mensagem: 'Nenhum atendimento encontrado.',
                icon: Icons.local_shipping_outlined,
              );
            }
            return ListView.builder(
              itemCount: state.atendimentos.length,
              itemBuilder: (context, index) {
                final at = state.atendimentos[index];
                return _AtendimentoTile(
                  atendimento: at,
                  onTap: () => _abrirDetalhe(context, at),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('novoAtendimentoFab'),
        onPressed: () => _iniciarNovoAtendimento(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _iniciarNovoAtendimento(BuildContext context) async {
    // 1. Selecionar cliente primeiro
    final bloc = context.read<AtendimentoBloc>();
    final cliente = await _selecionarCliente(context);
    if (cliente == null || !mounted) return;

    // 2. Carregar bases disponíveis
    final listarBases = GetIt.I<ListarBases>();
    final bases = await listarBases();
    final basePrincipal = bases.cast<Base?>().firstWhere(
          (b) => b!.isPrincipal,
          orElse: () => null,
        );

    if (!mounted) return;

    // 3. Obter usuário logado (simplificado — ID do auth state)
    // TODO: obter do AuthBloc quando disponível
    const usuarioId = 'usuario-logado';
    const valorPorKmDefault = 5.0;

    // ignore: use_build_context_synchronously
    final resultado = await Navigator.of(context).push<Atendimento>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: NovoAtendimentoPage(
            clienteId: cliente.id,
            usuarioId: usuarioId,
            valorPorKmDefault: valorPorKmDefault,
            geoService: GetIt.I<GeoService>(),
            basesDisponiveis: bases,
            basePrincipal: basePrincipal,
          ),
        ),
      ),
    );

    if (resultado != null && mounted) {
      _carregar();
    }
  }

  Future<Cliente?> _selecionarCliente(BuildContext ctx) async {
    final buscarClientes = GetIt.I<BuscarClientes>();
    final clientes = await buscarClientes('');

    if (!mounted) return null;

    return showModalBottomSheet<Cliente>(
      // ignore: use_build_context_synchronously
      context: ctx,
      isScrollControlled: true,
      builder: (ctx) => _SelecionarClienteSheet(clientes: clientes),
    );
  }

  void _abrirDetalhe(BuildContext context, Atendimento atendimento) async {
    final atndBloc = context.read<AtendimentoBloc>();
    final rastrBloc = context.read<RastreamentoBloc>();
    final resultado = await Navigator.of(context).push<Atendimento>(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: atndBloc),
            BlocProvider.value(value: rastrBloc),
          ],
          child: DetalheAtendimentoPage(atendimento: atendimento),
        ),
      ),
    );

    if (resultado != null && mounted) {
      _carregar();
    }
  }

  String _statusLabel(AtendimentoStatus s) {
    switch (s) {
      case AtendimentoStatus.rascunho:
        return 'Rascunho';
      case AtendimentoStatus.emDeslocamento:
        return 'Em Deslocamento';
      case AtendimentoStatus.emColeta:
        return 'Em Coleta';
      case AtendimentoStatus.emEntrega:
        return 'Em Entrega';
      case AtendimentoStatus.retornando:
        return 'Retornando';
      case AtendimentoStatus.concluido:
        return 'Concluído';
      case AtendimentoStatus.cancelado:
        return 'Cancelado';
    }
  }
}

class _SelecionarClienteSheet extends StatelessWidget {
  const _SelecionarClienteSheet({required this.clientes});

  final List<Cliente> clientes;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, controller) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Selecionar Cliente',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: clientes.isEmpty
                  ? const Center(child: Text('Nenhum cliente cadastrado.'))
                  : ListView.builder(
                      controller: controller,
                      itemCount: clientes.length,
                      itemBuilder: (_, i) {
                        final c = clientes[i];
                        return ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(c.nome),
                          subtitle: Text(c.telefone),
                          onTap: () => Navigator.of(context).pop(c),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _AtendimentoTile extends StatelessWidget {
  const _AtendimentoTile({
    required this.atendimento,
    this.onTap,
  });

  final Atendimento atendimento;
  final VoidCallback? onTap;

  (Color, Color) _statusColors() {
    final key = atendimento.status.name;
    return AppTheme.statusColors[key] ??
        (const Color(0xFFE3F2FD), const Color(0xFF0D47A1));
  }

  String _statusLabel() {
    switch (atendimento.status) {
      case AtendimentoStatus.rascunho:
        return 'Rascunho';
      case AtendimentoStatus.emDeslocamento:
        return 'Em Deslocamento';
      case AtendimentoStatus.emColeta:
        return 'Em Coleta';
      case AtendimentoStatus.emEntrega:
        return 'Em Entrega';
      case AtendimentoStatus.retornando:
        return 'Retornando';
      case AtendimentoStatus.concluido:
        return 'Concluído';
      case AtendimentoStatus.cancelado:
        return 'Cancelado';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final (bg, fg) = _statusColors();

    return Card(
      key: Key('atendimentoTile_${atendimento.id}'),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${atendimento.id.length > 8 ? atendimento.id.substring(0, 8) : atendimento.id}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Chip(
                      label: Text(
                        _statusLabel(),
                        style: TextStyle(fontSize: 11, color: fg),
                      ),
                      backgroundColor: bg,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      side: BorderSide.none,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${atendimento.localDeColeta.enderecoTexto} → '
                      '${atendimento.localDeEntrega.enderecoTexto}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.outline,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${atendimento.distanciaEstimadaKm.toStringAsFixed(1)} km',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.secondary,
                    ),
                  ),
                  if (atendimento.valorCobrado != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'R\$ ${atendimento.valorCobrado!.toStringAsFixed(2)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.outline,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

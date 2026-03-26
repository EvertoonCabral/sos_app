import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/geo/geo_service.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../bloc/base_bloc.dart';
import '../bloc/base_event.dart';
import '../bloc/base_state.dart';
import '../../domain/entities/base.dart';
import 'form_base_page.dart';

class GestaoBasesPage extends StatefulWidget {
  const GestaoBasesPage({super.key});

  @override
  State<GestaoBasesPage> createState() => _GestaoBasesPageState();
}

class _GestaoBasesPageState extends State<GestaoBasesPage> {
  @override
  void initState() {
    super.initState();
    context.read<BaseBloc>().add(const ListarBasesEvent());
  }

  void _definirPrincipal(String baseId) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Definir base principal'),
        content: const Text(
          'Tem certeza que deseja definir esta base como principal?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Não'),
          ),
          ElevatedButton(
            key: const Key('confirmarDefinirPrincipalButton'),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sim, definir'),
          ),
        ],
      ),
    );
    if (confirmou == true && mounted) {
      context.read<BaseBloc>().add(DefinirBasePrincipalEvent(baseId));
    }
  }

  void _abrirFormCriar() async {
    final bloc = context.read<BaseBloc>();
    final resultado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: FormBasePage(geoService: GetIt.I<GeoService>()),
        ),
      ),
    );
    if (resultado == true && mounted) {
      bloc.add(const ListarBasesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bases / Garagens'),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('addBaseButton'),
        onPressed: _abrirFormCriar,
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<BaseBloc, BaseState>(
        builder: (context, state) {
          if (state is BaseCarregando) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BaseErro) {
            return ErrorStateWidget(
              mensagem: state.mensagem,
              onRetry: () =>
                  context.read<BaseBloc>().add(const ListarBasesEvent()),
            );
          }
          if (state is BaseListaCarregada) {
            if (state.bases.isEmpty) {
              return const EmptyStateWidget(
                mensagem: 'Nenhuma base cadastrada.',
                icon: Icons.warehouse_outlined,
              );
            }
            return ListView.builder(
              itemCount: state.bases.length,
              itemBuilder: (context, index) {
                final base = state.bases[index];
                return _BaseTile(
                  base: base,
                  onDefinirPrincipal: () => _definirPrincipal(base.id),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _BaseTile extends StatelessWidget {
  const _BaseTile({
    required this.base,
    required this.onDefinirPrincipal,
  });

  final Base base;
  final VoidCallback onDefinirPrincipal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      key: Key('baseTile_${base.id}'),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: base.isPrincipal
                ? theme.colorScheme.secondaryContainer
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            base.isPrincipal ? Icons.star_rounded : Icons.warehouse_outlined,
            color: base.isPrincipal
                ? theme.colorScheme.secondary
                : theme.colorScheme.outline,
          ),
        ),
        title: Text(
          base.nome,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          base.local.enderecoTexto,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
        trailing: base.isPrincipal
            ? Chip(
                label: const Text('Principal'),
                backgroundColor: theme.colorScheme.secondaryContainer,
                labelStyle: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
                side: BorderSide.none,
              )
            : TextButton(
                key: Key('setPrincipal_${base.id}'),
                onPressed: onDefinirPrincipal,
                child: const Text('Definir'),
              ),
      ),
    );
  }
}

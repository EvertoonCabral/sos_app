import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../bloc/base_bloc.dart';
import '../bloc/base_event.dart';
import '../bloc/base_state.dart';
import '../../domain/entities/base.dart';

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

  void _definirPrincipal(String baseId) {
    context.read<BaseBloc>().add(DefinirBasePrincipalEvent(baseId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bases / Garagens'),
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
      color: base.isPrincipal ? theme.colorScheme.primaryContainer : null,
      child: ListTile(
        leading: Icon(
          base.isPrincipal ? Icons.star : Icons.warehouse_outlined,
          color: base.isPrincipal ? Colors.amber : null,
        ),
        title: Text(
          base.nome,
          style: base.isPrincipal
              ? const TextStyle(fontWeight: FontWeight.bold)
              : null,
        ),
        subtitle: Text(base.local.enderecoTexto),
        trailing: base.isPrincipal
            ? const Chip(label: Text('Principal'))
            : TextButton(
                key: Key('setPrincipal_${base.id}'),
                onPressed: onDefinirPrincipal,
                child: const Text('Definir'),
              ),
      ),
    );
  }
}

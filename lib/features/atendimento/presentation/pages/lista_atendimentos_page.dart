import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/atendimento.dart';
import '../../domain/entities/atendimento_enums.dart';
import '../bloc/atendimento_bloc.dart';
import '../bloc/atendimento_event.dart';
import '../bloc/atendimento_state.dart';

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
            return Center(
              child: Text(state.mensagem,
                  style: const TextStyle(color: Colors.red)),
            );
          }
          if (state is AtendimentoListaCarregada) {
            if (state.atendimentos.isEmpty) {
              return const Center(
                child: Text('Nenhum atendimento encontrado.'),
              );
            }
            return ListView.builder(
              itemCount: state.atendimentos.length,
              itemBuilder: (context, index) {
                final at = state.atendimentos[index];
                return _AtendimentoTile(atendimento: at);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('novoAtendimentoFab'),
        onPressed: () {
          // Navegar para NovoAtendimentoPage
        },
        child: const Icon(Icons.add),
      ),
    );
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

class _AtendimentoTile extends StatelessWidget {
  const _AtendimentoTile({required this.atendimento});

  final Atendimento atendimento;

  Color _statusColor() {
    switch (atendimento.status) {
      case AtendimentoStatus.rascunho:
        return Colors.grey;
      case AtendimentoStatus.emDeslocamento:
        return Colors.blue;
      case AtendimentoStatus.emColeta:
        return Colors.orange;
      case AtendimentoStatus.emEntrega:
        return Colors.deepPurple;
      case AtendimentoStatus.retornando:
        return Colors.teal;
      case AtendimentoStatus.concluido:
        return Colors.green;
      case AtendimentoStatus.cancelado:
        return Colors.red;
    }
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
    return Card(
      key: Key('atendimentoTile_${atendimento.id}'),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _statusColor(),
          child: const Icon(Icons.local_shipping, color: Colors.white),
        ),
        title: Text(
          '${atendimento.localDeColeta.enderecoTexto} → '
          '${atendimento.localDeEntrega.enderecoTexto}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${atendimento.distanciaEstimadaKm.toStringAsFixed(1)} km  •  '
          '${_statusLabel()}',
        ),
        trailing: Chip(
          label: Text(
            _statusLabel(),
            style: const TextStyle(fontSize: 10, color: Colors.white),
          ),
          backgroundColor: _statusColor(),
        ),
      ),
    );
  }
}

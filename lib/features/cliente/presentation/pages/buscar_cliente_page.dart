import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../domain/entities/cliente.dart';
import '../bloc/cliente_bloc.dart';
import '../bloc/cliente_event.dart';
import '../bloc/cliente_state.dart';
import 'form_cliente_page.dart';

class BuscarClientePage extends StatefulWidget {
  const BuscarClientePage({super.key});

  @override
  State<BuscarClientePage> createState() => _BuscarClientePageState();
}

class _BuscarClientePageState extends State<BuscarClientePage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Carrega todos os clientes ao abrir
    context.read<ClienteBloc>().add(const BuscarClientesEvent(''));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    context.read<ClienteBloc>().add(BuscarClientesEvent(query));
  }

  void _abrirFormCriar() async {
    final resultado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const FormClientePage()),
    );
    if (resultado == true && mounted) {
      context
          .read<ClienteBloc>()
          .add(BuscarClientesEvent(_searchController.text));
    }
  }

  void _abrirFormEditar(Cliente cliente) async {
    final resultado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => FormClientePage(cliente: cliente),
      ),
    );
    if (resultado == true && mounted) {
      context
          .read<ClienteBloc>()
          .add(BuscarClientesEvent(_searchController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('addClienteButton'),
        onPressed: _abrirFormCriar,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              key: const Key('searchClienteField'),
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar cliente...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearch('');
                  },
                ),
              ),
              onChanged: _onSearch,
            ),
          ),
          Expanded(
            child: BlocBuilder<ClienteBloc, ClienteState>(
              builder: (context, state) {
                if (state is ClienteCarregando) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ClienteErro) {
                  return ErrorStateWidget(
                    mensagem: state.mensagem,
                    onRetry: () => _onSearch(_searchController.text),
                  );
                }
                if (state is ClienteListaCarregada) {
                  if (state.clientes.isEmpty) {
                    return const EmptyStateWidget(
                      mensagem: 'Nenhum cliente encontrado.',
                      icon: Icons.people_outline,
                    );
                  }
                  return ListView.builder(
                    itemCount: state.clientes.length,
                    itemBuilder: (context, index) {
                      final c = state.clientes[index];
                      return ListTile(
                        key: Key('clienteTile_${c.id}'),
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(c.nome),
                        subtitle: Text(c.telefone),
                        onTap: () => _abrirFormEditar(c),
                      );
                    },
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

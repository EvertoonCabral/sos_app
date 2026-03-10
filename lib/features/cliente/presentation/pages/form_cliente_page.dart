import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cliente.dart';
import '../bloc/cliente_bloc.dart';
import '../bloc/cliente_event.dart';
import '../bloc/cliente_state.dart';

/// Tela de criação / edição de cliente.
/// Se [cliente] for informado, entra em modo edição.
class FormClientePage extends StatefulWidget {
  const FormClientePage({super.key, this.cliente});

  final Cliente? cliente;

  @override
  State<FormClientePage> createState() => _FormClientePageState();
}

class _FormClientePageState extends State<FormClientePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _telefoneController;
  late final TextEditingController _documentoController;

  bool get _editando => widget.cliente != null;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.cliente?.nome ?? '');
    _telefoneController =
        TextEditingController(text: widget.cliente?.telefone ?? '');
    _documentoController =
        TextEditingController(text: widget.cliente?.documento ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _documentoController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final bloc = context.read<ClienteBloc>();
    if (_editando) {
      final atualizado = widget.cliente!.copyWith(
        nome: _nomeController.text.trim(),
        telefone: _telefoneController.text.trim(),
        documento: _documentoController.text.trim().isEmpty
            ? null
            : _documentoController.text.trim(),
      );
      bloc.add(AtualizarClienteEvent(atualizado));
    } else {
      bloc.add(CriarClienteEvent(
        nome: _nomeController.text.trim(),
        telefone: _telefoneController.text.trim(),
        documento: _documentoController.text.trim().isEmpty
            ? null
            : _documentoController.text.trim(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar Cliente' : 'Novo Cliente'),
      ),
      body: BlocListener<ClienteBloc, ClienteState>(
        listener: (context, state) {
          if (state is ClienteSalvoComSucesso) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cliente salvo com sucesso!')),
            );
            Navigator.of(context).pop(true);
          }
          if (state is ClienteErro) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.mensagem),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  key: const Key('clienteNomeField'),
                  controller: _nomeController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Nome *',
                    prefixIcon: Icon(Icons.person_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Informe o nome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('clienteTelefoneField'),
                  controller: _telefoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Telefone *',
                    prefixIcon: Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Informe o telefone';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('clienteDocumentoField'),
                  controller: _documentoController,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Documento (CPF/CNPJ)',
                    prefixIcon: Icon(Icons.badge_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<ClienteBloc, ClienteState>(
                  builder: (context, state) {
                    final salvando = state is ClienteCarregando;
                    return SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        key: const Key('salvarClienteButton'),
                        onPressed: salvando ? null : _salvar,
                        child: salvando
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(_editando ? 'Salvar' : 'Criar Cliente'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

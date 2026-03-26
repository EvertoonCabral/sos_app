import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/entities/local_geo.dart';
import '../../../../core/geo/geo_service.dart';
import '../../../../core/widgets/local_selector/local_selector_opcao.dart';
import '../../../../core/widgets/local_selector/local_selector_widget.dart';
import '../../domain/entities/base.dart';
import '../bloc/base_bloc.dart';
import '../bloc/base_event.dart';
import '../bloc/base_state.dart';

class FormBasePage extends StatefulWidget {
  const FormBasePage({super.key, required this.geoService});

  final GeoService geoService;

  @override
  State<FormBasePage> createState() => _FormBasePageState();
}

class _FormBasePageState extends State<FormBasePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _complementoController = TextEditingController();
  LocalGeo? _local;

  @override
  void dispose() {
    _nomeController.dispose();
    _complementoController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_local == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a localização da base')),
      );
      return;
    }

    final local = _complementoController.text.trim().isEmpty
        ? _local!
        : LocalGeo(
            enderecoTexto: _local!.enderecoTexto,
            latitude: _local!.latitude,
            longitude: _local!.longitude,
            complemento: _complementoController.text.trim(),
          );

    context.read<BaseBloc>().add(CriarBaseEvent(Base(
          id: const Uuid().v4(),
          nome: _nomeController.text.trim(),
          local: local,
          criadoEm: DateTime.now(),
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Base')),
      body: BlocListener<BaseBloc, BaseState>(
        listener: (context, state) {
          if (state is BaseSalvaComSucesso) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Base cadastrada com sucesso!')),
            );
            Navigator.of(context).pop(true);
          }
          if (state is BaseErro) {
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  key: const Key('baseNomeField'),
                  controller: _nomeController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Nome da Base *',
                    prefixIcon: Icon(Icons.warehouse_outlined),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Informe o nome da base';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                LocalSelectorWidget(
                  label: 'Localização *',
                  opcoes: const [
                    LocalSelectorOpcao.digitarEndereco,
                    LocalSelectorOpcao.selecionarNoMapa,
                    LocalSelectorOpcao.localizacaoAtual,
                  ],
                  geoService: widget.geoService,
                  onLocalSelecionado: (local) {
                    setState(() => _local = local);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('baseComplementoField'),
                  controller: _complementoController,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Complemento (opcional)',
                    prefixIcon: Icon(Icons.info_outline),
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<BaseBloc, BaseState>(
                  builder: (context, state) {
                    final salvando = state is BaseCarregando;
                    return SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        key: const Key('salvarBaseButton'),
                        onPressed: salvando ? null : _salvar,
                        child: salvando
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Salvar'),
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

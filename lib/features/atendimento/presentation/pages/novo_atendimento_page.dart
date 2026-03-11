import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/entities/local_geo.dart';
import '../../../../core/geo/geo_service.dart';
import '../../../../core/widgets/local_selector/local_selector_opcao.dart';
import '../../../../core/widgets/local_selector/local_selector_widget.dart';
import '../../../base/domain/entities/base.dart';
import '../../domain/entities/atendimento_enums.dart';
import '../bloc/atendimento_bloc.dart';
import '../bloc/atendimento_event.dart';
import '../bloc/atendimento_state.dart';
import '../widgets/valor_selector_widget.dart';

/// Tela de criação de novo atendimento com 4 campos de localização.
/// RN-009B: Local de Retorno pré-preenchido com Ponto de Saída.
class NovoAtendimentoPage extends StatefulWidget {
  const NovoAtendimentoPage({
    super.key,
    required this.clienteId,
    required this.usuarioId,
    required this.valorPorKmDefault,
    required this.geoService,
    this.basesDisponiveis = const [],
    this.basePrincipal,
  });

  final String clienteId;
  final String usuarioId;
  final double valorPorKmDefault;
  final GeoService geoService;
  final List<Base> basesDisponiveis;
  final Base? basePrincipal;

  @override
  State<NovoAtendimentoPage> createState() => _NovoAtendimentoPageState();
}

class _NovoAtendimentoPageState extends State<NovoAtendimentoPage> {
  LocalGeo? _pontoDeSaida;
  LocalGeo? _localDeColeta;
  LocalGeo? _localDeEntrega;
  LocalGeo? _localDeRetorno;

  TipoValor _tipoValor = TipoValor.porKm;
  double? _valorFixo;
  final _observacoesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // RN-030: base principal pré-selecionada
    if (widget.basePrincipal != null) {
      _pontoDeSaida = widget.basePrincipal!.local;
      // RN-009B: retorno = saída
      _localDeRetorno = widget.basePrincipal!.local;
    }
  }

  @override
  void dispose() {
    _observacoesController.dispose();
    super.dispose();
  }

  bool get _formValido =>
      _pontoDeSaida != null &&
      _localDeColeta != null &&
      _localDeEntrega != null &&
      _localDeRetorno != null;

  void _salvar() {
    if (!_formValido) return;

    context.read<AtendimentoBloc>().add(CriarAtendimentoEvent(
          id: const Uuid().v4(),
          clienteId: widget.clienteId,
          usuarioId: widget.usuarioId,
          pontoDeSaida: _pontoDeSaida!,
          localDeColeta: _localDeColeta!,
          localDeEntrega: _localDeEntrega!,
          localDeRetorno: _localDeRetorno!,
          valorPorKm: widget.valorPorKmDefault,
          tipoValor: _tipoValor,
          valorFixo: _valorFixo,
          observacoes: _observacoesController.text.trim().isNotEmpty
              ? _observacoesController.text.trim()
              : null,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Atendimento')),
      body: BlocListener<AtendimentoBloc, AtendimentoState>(
        listener: (context, state) {
          if (state is AtendimentoSalvoComSucesso) {
            Navigator.of(context).pop(state.atendimento);
          }
          if (state is AtendimentoErro) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Ponto de Saída (todas as 4 opções) ---
              LocalSelectorWidget(
                label: 'Ponto de Saída',
                valorInicial: _pontoDeSaida,
                geoService: widget.geoService,
                basesDisponiveis: widget.basesDisponiveis,
                onLocalSelecionado: (local) {
                  setState(() {
                    _pontoDeSaida = local;
                    // RN-009B: atualiza retorno automaticamente
                    _localDeRetorno ??= local;
                  });
                },
              ),
              const SizedBox(height: 16),

              // --- Local de Coleta (endereço + mapa) ---
              LocalSelectorWidget(
                label: 'Local de Coleta',
                valorInicial: _localDeColeta,
                opcoes: const [
                  LocalSelectorOpcao.digitarEndereco,
                  LocalSelectorOpcao.selecionarNoMapa,
                ],
                geoService: widget.geoService,
                onLocalSelecionado: (local) {
                  setState(() => _localDeColeta = local);
                },
              ),
              const SizedBox(height: 16),

              // --- Local de Entrega (endereço + mapa) ---
              LocalSelectorWidget(
                label: 'Local de Entrega',
                valorInicial: _localDeEntrega,
                opcoes: const [
                  LocalSelectorOpcao.digitarEndereco,
                  LocalSelectorOpcao.selecionarNoMapa,
                ],
                geoService: widget.geoService,
                onLocalSelecionado: (local) {
                  setState(() => _localDeEntrega = local);
                },
              ),
              const SizedBox(height: 16),

              // --- Local de Retorno (todas as 4 opções, pré-preenchido) ---
              LocalSelectorWidget(
                label: 'Local de Retorno',
                valorInicial: _localDeRetorno,
                geoService: widget.geoService,
                basesDisponiveis: widget.basesDisponiveis,
                onLocalSelecionado: (local) {
                  setState(() => _localDeRetorno = local);
                },
              ),
              const SizedBox(height: 24),

              // --- Valor ---
              ValorSelectorWidget(
                tipoValor: _tipoValor,
                valorPorKm: widget.valorPorKmDefault,
                valorFixo: _valorFixo,
                onTipoValorChanged: (t) => setState(() => _tipoValor = t),
                onValorFixoChanged: (v) => setState(() => _valorFixo = v),
              ),
              const SizedBox(height: 16),

              // --- Observações ---
              TextField(
                key: const Key('observacoesField'),
                controller: _observacoesController,
                decoration: const InputDecoration(
                  labelText: 'Observações (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // --- Botão Salvar ---
              BlocBuilder<AtendimentoBloc, AtendimentoState>(
                builder: (context, state) {
                  final loading = state is AtendimentoCarregando;
                  return ElevatedButton(
                    key: const Key('salvarAtendimentoButton'),
                    onPressed: _formValido && !loading ? _salvar : null,
                    child: loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Criar Atendimento'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

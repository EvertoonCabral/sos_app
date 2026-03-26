import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/atendimento.dart';
import '../../domain/entities/atendimento_enums.dart';
import '../bloc/atendimento_bloc.dart';
import '../bloc/atendimento_event.dart';
import '../bloc/atendimento_state.dart';
import '../widgets/status_stepper_widget.dart';
import '../../../rastreamento/presentation/bloc/rastreamento_bloc.dart';
import '../../../rastreamento/presentation/bloc/rastreamento_event.dart';

/// Status que requerem coleta de GPS ativa.
const _statusComTracking = {
  AtendimentoStatus.emDeslocamento,
  AtendimentoStatus.emColeta,
  AtendimentoStatus.emEntrega,
  AtendimentoStatus.retornando,
};

/// Tela de detalhe do atendimento com stepper de 5 etapas.
class DetalheAtendimentoPage extends StatefulWidget {
  const DetalheAtendimentoPage({
    super.key,
    required this.atendimento,
  });

  final Atendimento atendimento;

  @override
  State<DetalheAtendimentoPage> createState() => _DetalheAtendimentoPageState();
}

class _DetalheAtendimentoPageState extends State<DetalheAtendimentoPage> {
  @override
  void initState() {
    super.initState();
    // Retoma o tracking se a tela foi reaberta com o atendimento já em andamento
    // (ex: app reiniciado durante o percurso).
    if (_statusComTracking.contains(widget.atendimento.status)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<RastreamentoBloc>().add(
                IniciarRastreamentoEvent(atendimentoId: widget.atendimento.id),
              );
        }
      });
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

  /// Retorna o próximo status válido (não cancelado) ou null.
  AtendimentoStatus? _proximoStatus() {
    final permitidos = transicoesValidas[widget.atendimento.status] ?? [];
    if (permitidos.isEmpty) return null;
    // Prefere o avanço natural (não cancelado)
    return permitidos.firstWhere(
      (s) => s != AtendimentoStatus.cancelado,
      orElse: () => permitidos.first,
    );
  }

  String _proximoStatusLabel() {
    final proximo = _proximoStatus();
    if (proximo == null) return '';
    switch (proximo) {
      case AtendimentoStatus.emDeslocamento:
        return 'Iniciar Deslocamento';
      case AtendimentoStatus.emColeta:
        return 'Cheguei para Coleta';
      case AtendimentoStatus.emEntrega:
        return 'Iniciar Entrega';
      case AtendimentoStatus.retornando:
        return 'Iniciar Retorno';
      case AtendimentoStatus.concluido:
        return 'Concluir Atendimento';
      default:
        return _statusLabel(proximo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AtendimentoBloc, AtendimentoState>(
      listener: (context, state) {
        if (state is AtendimentoStatusAtualizado) {
          final novoStatus = state.atendimento.status;
          // Inicia coleta GPS ao começar o deslocamento
          if (novoStatus == AtendimentoStatus.emDeslocamento) {
            context.read<RastreamentoBloc>().add(
                  IniciarRastreamentoEvent(atendimentoId: state.atendimento.id),
                );
          }
          // Encerra coleta GPS ao concluir ou cancelar
          if (novoStatus == AtendimentoStatus.concluido ||
              novoStatus == AtendimentoStatus.cancelado) {
            context
                .read<RastreamentoBloc>()
                .add(const PararRastreamentoEvent());
          }
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
      child: Scaffold(
        appBar: AppBar(
          title: Text('Atendimento #${widget.atendimento.id.substring(0, 8)}'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Info de locais ---
              _InfoCard(
                title: 'Ponto de Saída',
                texto: widget.atendimento.pontoDeSaida.enderecoTexto,
              ),
              _InfoCard(
                title: 'Local de Coleta',
                texto: widget.atendimento.localDeColeta.enderecoTexto,
              ),
              _InfoCard(
                title: 'Local de Entrega',
                texto: widget.atendimento.localDeEntrega.enderecoTexto,
              ),
              _InfoCard(
                title: 'Local de Retorno',
                texto: widget.atendimento.localDeRetorno.enderecoTexto,
              ),
              const SizedBox(height: 8),

              // --- Info de valores ---
              Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Distância Estimada: '
                        '${widget.atendimento.distanciaEstimadaKm.toStringAsFixed(1)} km',
                      ),
                      if (widget.atendimento.valorCobrado != null)
                        Text(
                          'Valor: R\$ ${widget.atendimento.valorCobrado!.toStringAsFixed(2)}',
                        ),
                      Text(
                        'Tipo: ${widget.atendimento.tipoValor == TipoValor.fixo ? "Fixo" : "Por KM"}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // --- Status e observações ---
              Text(
                'Status: ${_statusLabel(widget.atendimento.status)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (widget.atendimento.observacoes != null &&
                  widget.atendimento.observacoes!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Obs: ${widget.atendimento.observacoes}'),
                ),
              const SizedBox(height: 16),

              // --- Stepper ---
              StatusStepperWidget(statusAtual: widget.atendimento.status),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  Widget? _buildBottomBar(BuildContext context) {
    final proximo = _proximoStatus();
    if (proximo == null) return null;

    final podeAvancar =
        widget.atendimento.status != AtendimentoStatus.concluido &&
            widget.atendimento.status != AtendimentoStatus.cancelado;
    if (!podeAvancar) return null;

    return BlocBuilder<AtendimentoBloc, AtendimentoState>(
      builder: (context, state) {
        final loading = state is AtendimentoCarregando;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Cancelar
                if (widget.atendimento.status != AtendimentoStatus.concluido)
                  Expanded(
                    child: OutlinedButton(
                      key: const Key('cancelarAtendimentoButton'),
                      onPressed: loading
                          ? null
                          : () => context.read<AtendimentoBloc>().add(
                                AtualizarStatusEvent(
                                  atendimento: widget.atendimento,
                                  novoStatus: AtendimentoStatus.cancelado,
                                ),
                              ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                const SizedBox(width: 12),
                // Avançar
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    key: const Key('avancarStatusButton'),
                    onPressed: loading
                        ? null
                        : () => context.read<AtendimentoBloc>().add(
                              AtualizarStatusEvent(
                                atendimento: widget.atendimento,
                                novoStatus: proximo,
                              ),
                            ),
                    child: loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_proximoStatusLabel()),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.texto});

  final String title;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.location_on_outlined),
        title: Text(title),
        subtitle: Text(texto),
      ),
    );
  }
}

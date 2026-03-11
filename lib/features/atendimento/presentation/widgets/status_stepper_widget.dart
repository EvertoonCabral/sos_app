import 'package:flutter/material.dart';

import '../../domain/entities/atendimento_enums.dart';

/// Widget que exibe o stepper de 5 etapas do atendimento.
/// Etapas: Deslocamento → Coleta → Entrega → Retorno → Concluído
class StatusStepperWidget extends StatelessWidget {
  const StatusStepperWidget({
    super.key,
    required this.statusAtual,
  });

  final AtendimentoStatus statusAtual;

  static const _etapas = [
    AtendimentoStatus.emDeslocamento,
    AtendimentoStatus.emColeta,
    AtendimentoStatus.emEntrega,
    AtendimentoStatus.retornando,
    AtendimentoStatus.concluido,
  ];

  static const _labels = {
    AtendimentoStatus.emDeslocamento: 'Deslocamento',
    AtendimentoStatus.emColeta: 'Coleta',
    AtendimentoStatus.emEntrega: 'Entrega',
    AtendimentoStatus.retornando: 'Retorno',
    AtendimentoStatus.concluido: 'Concluído',
  };

  int get _currentStepIndex {
    if (statusAtual == AtendimentoStatus.rascunho ||
        statusAtual == AtendimentoStatus.cancelado) {
      return -1;
    }
    return _etapas.indexOf(statusAtual);
  }

  @override
  Widget build(BuildContext context) {
    if (statusAtual == AtendimentoStatus.cancelado) {
      return const Center(
        child: Chip(
          avatar: Icon(Icons.cancel, color: Colors.white),
          label: Text('Cancelado', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
    }

    final currentIdx = _currentStepIndex;

    return Stepper(
      key: const Key('statusStepper'),
      currentStep: currentIdx < 0 ? 0 : currentIdx,
      controlsBuilder: (context, details) => const SizedBox.shrink(),
      steps: List.generate(_etapas.length, (i) {
        final etapa = _etapas[i];
        StepState stepState;
        if (i < currentIdx) {
          stepState = StepState.complete;
        } else if (i == currentIdx) {
          stepState = StepState.editing;
        } else {
          stepState = StepState.indexed;
        }

        return Step(
          title: Text(_labels[etapa]!),
          content: const SizedBox.shrink(),
          isActive: i <= currentIdx,
          state: stepState,
        );
      }),
    );
  }
}

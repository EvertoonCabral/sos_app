import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sos_app/features/atendimento/domain/entities/atendimento_enums.dart';
import 'package:sos_app/features/atendimento/presentation/widgets/status_stepper_widget.dart';

void main() {
  Widget buildWidget(AtendimentoStatus status) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: StatusStepperWidget(statusAtual: status),
        ),
      ),
    );
  }

  group('StatusStepperWidget', () {
    testWidgets('deve exibir Stepper com 5 etapas para status normal',
        (tester) async {
      await tester.pumpWidget(buildWidget(AtendimentoStatus.emDeslocamento));

      expect(find.byKey(const Key('statusStepper')), findsOneWidget);
      expect(find.text('Deslocamento'), findsOneWidget);
      expect(find.text('Coleta'), findsOneWidget);
      expect(find.text('Entrega'), findsOneWidget);
      expect(find.text('Retorno'), findsOneWidget);
      expect(find.text('Concluído'), findsOneWidget);
    });

    testWidgets('deve exibir chip de Cancelado para status cancelado',
        (tester) async {
      await tester.pumpWidget(buildWidget(AtendimentoStatus.cancelado));

      expect(find.text('Cancelado'), findsOneWidget);
      expect(find.byIcon(Icons.cancel), findsOneWidget);
      expect(find.byKey(const Key('statusStepper')), findsNothing);
    });

    testWidgets('deve exibir stepper para status rascunho', (tester) async {
      await tester.pumpWidget(buildWidget(AtendimentoStatus.rascunho));

      expect(find.byKey(const Key('statusStepper')), findsOneWidget);
    });

    testWidgets('deve exibir stepper para status concluído', (tester) async {
      await tester.pumpWidget(buildWidget(AtendimentoStatus.concluido));

      expect(find.byKey(const Key('statusStepper')), findsOneWidget);
      expect(find.text('Concluído'), findsOneWidget);
    });

    testWidgets('deve exibir stepper para emColeta no passo correto',
        (tester) async {
      await tester.pumpWidget(buildWidget(AtendimentoStatus.emColeta));

      expect(find.byKey(const Key('statusStepper')), findsOneWidget);
    });
  });
}

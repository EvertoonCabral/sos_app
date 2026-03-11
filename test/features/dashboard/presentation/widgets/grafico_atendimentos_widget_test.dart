import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sos_app/features/dashboard/presentation/widgets/grafico_atendimentos_widget.dart';

void main() {
  Widget buildWidget({Map<DateTime, int>? data}) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: GraficoAtendimentosWidget(
            atendimentosPorDia: data ??
                {
                  DateTime(2026, 3, 10): 3,
                  DateTime(2026, 3, 11): 5,
                  DateTime(2026, 3, 12): 2,
                },
          ),
        ),
      ),
    );
  }

  testWidgets('exibe título', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.text('Atendimentos por Dia'), findsOneWidget);
  });

  testWidgets('exibe contagens', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.text('3'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('exibe datas formatadas', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.text('10/03'), findsOneWidget);
    expect(find.text('11/03'), findsOneWidget);
    expect(find.text('12/03'), findsOneWidget);
  });

  testWidgets('exibe mensagem quando sem dados', (tester) async {
    await tester.pumpWidget(buildWidget(data: {}));

    expect(
        find.text('Nenhum atendimento concluído no período'), findsOneWidget);
  });
}

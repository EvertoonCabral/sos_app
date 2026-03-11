import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sos_app/features/dashboard/domain/entities/resumo_periodo.dart';
import 'package:sos_app/features/dashboard/presentation/widgets/metricas_cards_widget.dart';

void main() {
  const resumo = ResumoPeriodo(
    kmOperacional: 150.5,
    kmCobrado: 150.5,
    receitaTotal: 752.50,
    totalAtendimentos: 20,
    totalConcluidos: 15,
    totalCancelados: 2,
    totalEmAndamento: 3,
  );

  Widget buildWidget() {
    return const MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: MetricasCardsWidget(resumo: resumo),
        ),
      ),
    );
  }

  testWidgets('exibe KM Operacional', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.text('KM Operacional'), findsOneWidget);
    expect(find.byKey(const Key('cardKmOperacional')), findsOneWidget);
  });

  testWidgets('exibe KM Cobrado', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.text('KM Cobrado'), findsOneWidget);
    expect(find.byKey(const Key('cardKmCobrado')), findsOneWidget);
  });

  testWidgets('exibe Receita', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.text('Receita'), findsOneWidget);
    expect(find.text('R\$ 752.50'), findsOneWidget);
  });

  testWidgets('exibe total de Atendimentos', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.text('Atendimentos'), findsOneWidget);
    expect(find.text('20'), findsOneWidget);
  });

  testWidgets('exibe Concluídos', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.text('Concluídos'), findsOneWidget);
    expect(find.text('15'), findsOneWidget);
  });

  testWidgets('exibe Em Andamento', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.text('Em Andamento'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('contém keys corretas nos cards', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.byKey(const Key('cardKmOperacional')), findsOneWidget);
    expect(find.byKey(const Key('cardKmCobrado')), findsOneWidget);
    expect(find.byKey(const Key('cardReceita')), findsOneWidget);
    expect(find.byKey(const Key('cardAtendimentos')), findsOneWidget);
    expect(find.byKey(const Key('cardConcluidos')), findsOneWidget);
    expect(find.byKey(const Key('cardEmAndamento')), findsOneWidget);
  });
}

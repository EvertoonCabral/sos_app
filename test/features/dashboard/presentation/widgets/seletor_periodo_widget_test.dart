import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sos_app/features/dashboard/presentation/widgets/seletor_periodo_widget.dart';

void main() {
  Widget buildWidget({
    void Function(PeriodoTipo, DateTime, DateTime)? onPeriodoSelecionado,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SeletorPeriodoWidget(
          onPeriodoSelecionado: onPeriodoSelecionado ?? (_, __, ___) {},
        ),
      ),
    );
  }

  testWidgets('exibe segmentos de período', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.text('Hoje'), findsOneWidget);
    expect(find.text('Semana'), findsOneWidget);
    expect(find.text('Mês'), findsOneWidget);
    expect(find.text('Custom'), findsOneWidget);
  });

  testWidgets('seleciona Hoje e dispara callback', (tester) async {
    PeriodoTipo? tipoRecebido;
    DateTime? inicioRecebido;

    await tester.pumpWidget(buildWidget(
      onPeriodoSelecionado: (tipo, inicio, fim) {
        tipoRecebido = tipo;
        inicioRecebido = inicio;
      },
    ));

    await tester.tap(find.text('Hoje'));
    await tester.pumpAndSettle();

    expect(tipoRecebido, PeriodoTipo.hoje);
    expect(inicioRecebido, isNotNull);
    // Should be today at 00:00:00
    final agora = DateTime.now();
    expect(inicioRecebido!.year, agora.year);
    expect(inicioRecebido!.month, agora.month);
    expect(inicioRecebido!.day, agora.day);
    expect(inicioRecebido!.hour, 0);
  });

  testWidgets('seleciona Semana e dispara callback', (tester) async {
    PeriodoTipo? tipoRecebido;

    await tester.pumpWidget(buildWidget(
      onPeriodoSelecionado: (tipo, inicio, fim) {
        tipoRecebido = tipo;
      },
    ));

    await tester.tap(find.text('Semana'));
    await tester.pumpAndSettle();

    expect(tipoRecebido, PeriodoTipo.semana);
  });

  testWidgets('SegmentedButton tem 4 segmentos', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.byType(SegmentedButton<PeriodoTipo>), findsOneWidget);
  });
}

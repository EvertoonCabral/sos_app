import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sos_app/features/dashboard/domain/entities/tempo_por_etapa.dart';
import 'package:sos_app/features/dashboard/presentation/widgets/tempo_por_etapa_widget.dart';

void main() {
  const tempos = TempoPorEtapa(
    mediaMinutosAteColeta: 25.5,
    mediaMinutosColetaEntrega: 35.0,
    mediaMinutosEntregaRetorno: 5.0,
    mediaMinutosRetornoBase: 90.0,
    totalAnalisados: 15,
  );

  Widget buildWidget({TempoPorEtapa? data}) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: TempoPorEtapaWidget(tempoPorEtapa: data ?? tempos),
        ),
      ),
    );
  }

  testWidgets('exibe título', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.text('Tempo Médio por Etapa'), findsOneWidget);
  });

  testWidgets('exibe total analisados', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.text('15 atendimentos analisados'), findsOneWidget);
  });

  testWidgets('exibe etapas', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.text('Até Coleta'), findsOneWidget);
    expect(find.text('Coleta → Entrega'), findsOneWidget);
    expect(find.text('Entrega → Retorno'), findsOneWidget);
    expect(find.text('Retorno à Base'), findsOneWidget);
  });

  testWidgets('formata minutos corretamente', (tester) async {
    await tester.pumpWidget(buildWidget());

    // 25.5 min → "26 min" (rounded)
    expect(find.text('26 min'), findsOneWidget);
    // 35 min → "35 min"
    expect(find.text('35 min'), findsOneWidget);
    // 5 min → "5 min"
    expect(find.text('5 min'), findsOneWidget);
    // 90 min → "1h 30min"
    expect(find.text('1h 30min'), findsOneWidget);
  });

  testWidgets('exibe mensagem quando sem dados', (tester) async {
    const vazio = TempoPorEtapa(
      mediaMinutosAteColeta: 0,
      mediaMinutosColetaEntrega: 0,
      mediaMinutosEntregaRetorno: 0,
      mediaMinutosRetornoBase: 0,
      totalAnalisados: 0,
    );
    await tester.pumpWidget(buildWidget(data: vazio));

    expect(find.text('Nenhum atendimento completo para análise de tempo'),
        findsOneWidget);
  });

  testWidgets('exibe ícones das etapas', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.byIcon(Icons.directions_car), findsOneWidget);
    expect(find.byIcon(Icons.local_shipping), findsOneWidget);
    expect(find.byIcon(Icons.swap_horiz), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
  });
}

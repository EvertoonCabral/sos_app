import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sos_app/features/dashboard/domain/entities/resumo_cliente.dart';
import 'package:sos_app/features/dashboard/presentation/widgets/ranking_clientes_widget.dart';

void main() {
  final ranking = [
    const ResumoCliente(
      clienteId: 'c1',
      clienteNome: 'João Silva',
      totalAtendimentos: 10,
      totalKm: 250.5,
      totalReceita: 1252.50,
    ),
    const ResumoCliente(
      clienteId: 'c2',
      clienteNome: 'Maria Santos',
      totalAtendimentos: 5,
      totalKm: 120.0,
      totalReceita: 600.00,
    ),
    const ResumoCliente(
      clienteId: 'c3',
      clienteNome: 'Pedro Oliveira',
      totalAtendimentos: 3,
      totalKm: 80.0,
      totalReceita: 400.00,
    ),
  ];

  Widget buildWidget({List<ResumoCliente>? data}) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: RankingClientesWidget(ranking: data ?? ranking),
        ),
      ),
    );
  }

  testWidgets('exibe título Ranking de Clientes', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.text('Ranking de Clientes'), findsOneWidget);
  });

  testWidgets('exibe nomes dos clientes', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.text('João Silva'), findsOneWidget);
    expect(find.text('Maria Santos'), findsOneWidget);
    expect(find.text('Pedro Oliveira'), findsOneWidget);
  });

  testWidgets('exibe receita dos clientes', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.text('R\$ 1252.50'), findsOneWidget);
    expect(find.text('R\$ 600.00'), findsOneWidget);
  });

  testWidgets('exibe medalhas para top 3', (tester) async {
    await tester.pumpWidget(buildWidget());

    // 3 medals for top 3
    expect(find.byIcon(Icons.emoji_events), findsNWidgets(3));
  });

  testWidgets('exibe mensagem quando lista vazia', (tester) async {
    await tester.pumpWidget(buildWidget(data: []));

    expect(
        find.text('Nenhum atendimento concluído no período'), findsOneWidget);
  });

  testWidgets('exibe KM e atendimentos por cliente', (tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.text('10 atendimentos • 250.5 km'), findsOneWidget);
    expect(find.text('5 atendimentos • 120.0 km'), findsOneWidget);
  });
}

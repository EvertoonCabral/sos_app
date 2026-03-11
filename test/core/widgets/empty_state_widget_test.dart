import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sos_app/core/widgets/empty_state_widget.dart';

void main() {
  group('EmptyStateWidget', () {
    testWidgets('deve exibir mensagem e ícone padrão', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(mensagem: 'Nenhum item encontrado'),
          ),
        ),
      );

      expect(find.text('Nenhum item encontrado'), findsOneWidget);
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('deve exibir ícone customizado', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              mensagem: 'Sem clientes',
              icon: Icons.people_outline,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.people_outline), findsOneWidget);
    });

    testWidgets('deve exibir botão de ação quando fornecido', (tester) async {
      var acaoClicada = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              mensagem: 'Nenhum dado',
              actionLabel: 'Criar novo',
              onAction: () => acaoClicada = true,
            ),
          ),
        ),
      );

      expect(find.text('Criar novo'), findsOneWidget);
      await tester.tap(find.text('Criar novo'));
      await tester.pump();
      expect(acaoClicada, isTrue);
    });

    testWidgets('não deve exibir botão sem actionLabel', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(mensagem: 'Vazio'),
          ),
        ),
      );

      expect(find.byType(FilledButton), findsNothing);
    });
  });
}

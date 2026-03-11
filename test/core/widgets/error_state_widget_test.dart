import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sos_app/core/widgets/error_state_widget.dart';

void main() {
  group('ErrorStateWidget', () {
    testWidgets('deve exibir mensagem de erro e ícone', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(mensagem: 'Erro ao carregar dados'),
          ),
        ),
      );

      expect(find.text('Erro ao carregar dados'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('deve exibir botão retry quando callback fornecido',
        (tester) async {
      var retryClicado = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              mensagem: 'Falha',
              onRetry: () => retryClicado = true,
            ),
          ),
        ),
      );

      expect(find.text('Tentar novamente'), findsOneWidget);

      await tester.tap(find.byKey(const Key('retryButton')));
      await tester.pump();

      expect(retryClicado, isTrue);
    });

    testWidgets('não deve exibir botão retry sem callback', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(mensagem: 'Erro'),
          ),
        ),
      );

      expect(find.text('Tentar novamente'), findsNothing);
    });

    testWidgets('deve exibir ícone customizado', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              mensagem: 'Sem rede',
              icon: Icons.wifi_off,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    });
  });
}

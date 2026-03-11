import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sos_app/features/atendimento/domain/entities/atendimento_enums.dart';
import 'package:sos_app/features/atendimento/presentation/widgets/valor_selector_widget.dart';

void main() {
  group('ValorSelectorWidget', () {
    testWidgets('deve exibir modo porKm com valor por km', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValorSelectorWidget(
              tipoValor: TipoValor.porKm,
              valorPorKm: 5.00,
              onTipoValorChanged: (_) {},
              onValorFixoChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Tipo de Valor'), findsOneWidget);
      expect(find.textContaining('5.00'), findsOneWidget);
      expect(find.byKey(const Key('tipoValorSegmented')), findsOneWidget);
    });

    testWidgets('deve exibir campo de valor fixo no modo fixo', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValorSelectorWidget(
              tipoValor: TipoValor.fixo,
              valorPorKm: 5.00,
              valorFixo: 150.0,
              onTipoValorChanged: (_) {},
              onValorFixoChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('valorFixoField')), findsOneWidget);
    });

    testWidgets('deve chamar callback ao alterar valor fixo', (tester) async {
      double? valorRecebido;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValorSelectorWidget(
              tipoValor: TipoValor.fixo,
              valorPorKm: 5.00,
              onTipoValorChanged: (_) {},
              onValorFixoChanged: (v) => valorRecebido = v,
            ),
          ),
        ),
      );

      await tester.enterText(
        find.byKey(const Key('valorFixoField')),
        '200',
      );
      await tester.pump();

      expect(valorRecebido, 200.0);
    });

    testWidgets('deve exibir segmented button com duas opções', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValorSelectorWidget(
              tipoValor: TipoValor.porKm,
              valorPorKm: 5.00,
              onTipoValorChanged: (_) {},
              onValorFixoChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Por KM'), findsOneWidget);
      expect(find.text('Fixo'), findsOneWidget);
    });
  });
}

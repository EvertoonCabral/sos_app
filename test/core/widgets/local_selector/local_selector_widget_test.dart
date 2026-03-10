import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/entities/local_geo.dart';
import 'package:sos_app/core/geo/geo_service.dart';
import 'package:sos_app/core/widgets/local_selector/local_selector_opcao.dart';
import 'package:sos_app/core/widgets/local_selector/local_selector_widget.dart';
import 'package:sos_app/features/base/domain/entities/base.dart';

class MockGeoService extends Mock implements GeoService {}

void main() {
  late MockGeoService mockGeoService;

  setUp(() {
    mockGeoService = MockGeoService();
  });

  Widget buildWidget({
    LocalGeo? valorInicial,
    List<LocalSelectorOpcao> opcoes = LocalSelectorOpcao.values,
    List<Base> basesDisponiveis = const [],
    ValueChanged<LocalGeo>? onLocalSelecionado,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: LocalSelectorWidget(
          label: 'Local de Teste',
          onLocalSelecionado: onLocalSelecionado ?? (_) {},
          valorInicial: valorInicial,
          opcoes: opcoes,
          geoService: mockGeoService,
          basesDisponiveis: basesDisponiveis,
        ),
      ),
    );
  }

  group('LocalSelectorWidget', () {
    testWidgets('exibe label e placeholder quando sem valor inicial',
        (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Local de Teste'), findsOneWidget);
      expect(find.text('Toque para selecionar...'), findsOneWidget);
    });

    testWidgets('exibe endereço quando valor inicial é fornecido',
        (tester) async {
      const local = LocalGeo(
        enderecoTexto: 'Rua Augusta, 100',
        latitude: -23.55,
        longitude: -46.65,
      );

      await tester.pumpWidget(buildWidget(valorInicial: local));

      expect(find.text('Rua Augusta, 100'), findsOneWidget);
      expect(find.text('Toque para selecionar...'), findsNothing);
    });

    testWidgets('abre bottom sheet com todas as opções ao tocar',
        (tester) async {
      await tester.pumpWidget(buildWidget());

      await tester.tap(find.byKey(const Key('localSelectorTap')));
      await tester.pumpAndSettle();

      expect(find.text('Localização Atual'), findsOneWidget);
      expect(find.text('Selecionar Base'), findsOneWidget);
      expect(find.text('Digitar Endereço'), findsOneWidget);
      expect(find.text('Selecionar no Mapa'), findsOneWidget);
    });

    testWidgets('filtra opções conforme parâmetro opcoes', (tester) async {
      await tester.pumpWidget(buildWidget(
        opcoes: [
          LocalSelectorOpcao.digitarEndereco,
          LocalSelectorOpcao.selecionarNoMapa,
        ],
      ));

      await tester.tap(find.byKey(const Key('localSelectorTap')));
      await tester.pumpAndSettle();

      expect(find.text('Localização Atual'), findsNothing);
      expect(find.text('Selecionar Base'), findsNothing);
      expect(find.text('Digitar Endereço'), findsOneWidget);
      expect(find.text('Selecionar no Mapa'), findsOneWidget);
    });

    testWidgets('opção Localização Atual chama geoService e atualiza endereço',
        (tester) async {
      const localRetornado = LocalGeo(
        enderecoTexto: 'Av Paulista, 1000',
        latitude: -23.56,
        longitude: -46.66,
      );
      when(() => mockGeoService.obterLocalizacaoAtual())
          .thenAnswer((_) async => localRetornado);

      LocalGeo? resultado;
      await tester.pumpWidget(buildWidget(
        onLocalSelecionado: (l) => resultado = l,
      ));

      // Abrir bottom sheet
      await tester.tap(find.byKey(const Key('localSelectorTap')));
      await tester.pumpAndSettle();

      // Selecionar "Localização Atual"
      await tester.tap(find.byKey(const Key('opcaoLocalizacaoAtual')));
      await tester.pumpAndSettle();

      expect(resultado, equals(localRetornado));
      expect(find.text('Av Paulista, 1000'), findsOneWidget);
      verify(() => mockGeoService.obterLocalizacaoAtual()).called(1);
    });

    testWidgets('opção Selecionar Base exibe lista de bases', (tester) async {
      final bases = [
        Base(
          id: '1',
          nome: 'Base Central',
          local: const LocalGeo(
            enderecoTexto: 'Rua A, 10',
            latitude: -23.5,
            longitude: -46.6,
          ),
          isPrincipal: true,
          criadoEm: DateTime(2024, 1, 1),
        ),
        Base(
          id: '2',
          nome: 'Base Norte',
          local: const LocalGeo(
            enderecoTexto: 'Rua B, 20',
            latitude: -23.4,
            longitude: -46.5,
          ),
          criadoEm: DateTime(2024, 1, 2),
        ),
      ];

      await tester.pumpWidget(buildWidget(basesDisponiveis: bases));

      // Abrir bottom sheet principal
      await tester.tap(find.byKey(const Key('localSelectorTap')));
      await tester.pumpAndSettle();

      // Selecionar opção "Selecionar Base"
      await tester.tap(find.byKey(const Key('opcaoSelecionarBase')));
      await tester.pumpAndSettle();

      // Bottom sheet de bases deve mostrar as bases
      expect(find.text('Base Central'), findsOneWidget);
      expect(find.text('Base Norte'), findsOneWidget);
    });

    testWidgets('selecionar base atualiza endereço', (tester) async {
      final bases = [
        Base(
          id: '1',
          nome: 'Base Central',
          local: const LocalGeo(
            enderecoTexto: 'Rua A, 10',
            latitude: -23.5,
            longitude: -46.6,
          ),
          isPrincipal: true,
          criadoEm: DateTime(2024, 1, 1),
        ),
      ];

      LocalGeo? resultado;
      await tester.pumpWidget(buildWidget(
        basesDisponiveis: bases,
        onLocalSelecionado: (l) => resultado = l,
      ));

      // Abrir bottom sheet → Selecionar Base
      await tester.tap(find.byKey(const Key('localSelectorTap')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('opcaoSelecionarBase')));
      await tester.pumpAndSettle();

      // Toque na base
      await tester.tap(find.byKey(const Key('baseOption_1')));
      await tester.pumpAndSettle();

      expect(resultado?.enderecoTexto, 'Rua A, 10');
      expect(find.text('Rua A, 10'), findsOneWidget);
    });

    testWidgets(
        'exibe "Nenhuma base cadastrada." quando lista de bases está vazia',
        (tester) async {
      await tester.pumpWidget(buildWidget(basesDisponiveis: []));

      await tester.tap(find.byKey(const Key('localSelectorTap')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('opcaoSelecionarBase')));
      await tester.pumpAndSettle();

      expect(find.text('Nenhuma base cadastrada.'), findsOneWidget);
    });

    testWidgets('Localização Atual retornando null não altera estado',
        (tester) async {
      when(() => mockGeoService.obterLocalizacaoAtual())
          .thenAnswer((_) async => null);

      await tester.pumpWidget(buildWidget());

      await tester.tap(find.byKey(const Key('localSelectorTap')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('opcaoLocalizacaoAtual')));
      await tester.pumpAndSettle();

      // Placeholder permanece
      expect(find.text('Toque para selecionar...'), findsOneWidget);
    });
  });
}

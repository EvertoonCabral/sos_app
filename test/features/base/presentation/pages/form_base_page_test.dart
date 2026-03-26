import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/entities/local_geo.dart';
import 'package:sos_app/core/geo/geo_service.dart';
import 'package:sos_app/features/base/domain/entities/base.dart';
import 'package:sos_app/features/base/presentation/bloc/base_bloc.dart';
import 'package:sos_app/features/base/presentation/bloc/base_event.dart';
import 'package:sos_app/features/base/presentation/bloc/base_state.dart';
import 'package:sos_app/features/base/presentation/pages/form_base_page.dart';

class MockBaseBloc extends MockBloc<BaseEvent, BaseState> implements BaseBloc {}

class MockGeoService extends Mock implements GeoService {}

class _FakeBaseEvent extends Fake implements BaseEvent {}

void main() {
  late MockBaseBloc mockBloc;
  late MockGeoService mockGeoService;

  setUpAll(() {
    registerFallbackValue(_FakeBaseEvent());
    registerFallbackValue(
      Base(
        id: 'fb',
        nome: 'fb',
        local: const LocalGeo(enderecoTexto: 'fb', latitude: 0, longitude: 0),
        criadoEm: DateTime(2026),
      ),
    );
  });

  setUp(() {
    mockBloc = MockBaseBloc();
    mockGeoService = MockGeoService();
    when(() => mockBloc.state).thenReturn(const BaseInicial());
  });

  Widget buildPage() {
    return MaterialApp(
      home: BlocProvider<BaseBloc>.value(
        value: mockBloc,
        child: FormBasePage(geoService: mockGeoService),
      ),
    );
  }

  /// Abre FormBasePage via push sobre uma página raiz para poder testar pop.
  Widget buildPageComNavegacao() {
    return MaterialApp(
      home: BlocProvider<BaseBloc>.value(
        value: mockBloc,
        child: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider<BaseBloc>.value(
                    value: mockBloc,
                    child: FormBasePage(geoService: mockGeoService),
                  ),
                ),
              ),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Renderização ────────────────────────────────────────────

  group('Renderização', () {
    testWidgets('deve exibir título, campos e botão salvar', (tester) async {
      await tester.pumpWidget(buildPage());

      expect(find.text('Nova Base'), findsOneWidget);
      expect(find.byKey(const Key('baseNomeField')), findsOneWidget);
      expect(find.byKey(const Key('baseComplementoField')), findsOneWidget);
      expect(find.byKey(const Key('salvarBaseButton')), findsOneWidget);
    });

    testWidgets('botão deve estar desabilitado quando estado é BaseCarregando',
        (tester) async {
      when(() => mockBloc.state).thenReturn(const BaseCarregando());
      await tester.pumpWidget(buildPage());

      final button = tester.widget<ElevatedButton>(
        find.byKey(const Key('salvarBaseButton')),
      );
      expect(button.onPressed, isNull);
    });
  });

  // ─── Validação ───────────────────────────────────────────────

  group('Validação', () {
    testWidgets('deve exibir erro quando nome está vazio', (tester) async {
      await tester.pumpWidget(buildPage());

      await tester.tap(find.byKey(const Key('salvarBaseButton')));
      await tester.pump();

      expect(find.text('Informe o nome da base'), findsOneWidget);
    });

    testWidgets('deve exibir snackbar quando localização não é selecionada',
        (tester) async {
      await tester.pumpWidget(buildPage());

      await tester.enterText(
        find.byKey(const Key('baseNomeField')),
        'Garagem SP',
      );
      await tester.tap(find.byKey(const Key('salvarBaseButton')));
      await tester.pump();

      expect(
        find.text('Selecione a localização da base'),
        findsOneWidget,
      );
    });
  });

  // ─── Estados do BLoC ─────────────────────────────────────────

  group('Estados do BLoC', () {
    testWidgets('deve exibir snackbar de sucesso e fechar a página',
        (tester) async {
      final tBase = Base(
        id: 'b-001',
        nome: 'Garagem SP',
        local: const LocalGeo(
          enderecoTexto: 'Rua X, 100',
          latitude: -23.5,
          longitude: -46.6,
        ),
        criadoEm: DateTime(2026, 3, 1),
      );

      whenListen(
        mockBloc,
        Stream.fromIterable([
          const BaseInicial(),
          BaseSalvaComSucesso(tBase),
        ]),
        initialState: const BaseInicial(),
      );

      await tester.pumpWidget(buildPageComNavegacao());

      await tester.tap(find.text('Abrir'));
      await tester.pump();
      await tester.pump(); // processa stream

      expect(find.text('Base cadastrada com sucesso!'), findsOneWidget);

      await tester.pumpAndSettle();
      // FormBasePage foi removido da pilha de navegação
      expect(find.text('Nova Base'), findsNothing);
    });

    testWidgets('deve exibir snackbar de erro quando BaseErro', (tester) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([
          const BaseInicial(),
          const BaseErro('Falha ao salvar'),
        ]),
        initialState: const BaseInicial(),
      );

      await tester.pumpWidget(buildPage());
      await tester.pump();

      expect(find.text('Falha ao salvar'), findsOneWidget);
    });
  });

  // ─── Dispatch de eventos ─────────────────────────────────────

  group('Dispatch de eventos', () {
    testWidgets(
        'deve disparar CriarBaseEvent com nome e localização ao salvar',
        (tester) async {
      const tLocal = LocalGeo(
        enderecoTexto: 'Rua X, 100',
        latitude: -23.5,
        longitude: -46.6,
      );
      when(() => mockGeoService.obterLocalizacaoAtual())
          .thenAnswer((_) async => tLocal);

      await tester.pumpWidget(buildPage());

      // Preenche nome
      await tester.enterText(
        find.byKey(const Key('baseNomeField')),
        'Garagem SP',
      );

      // Seleciona localização via opção "Localização Atual"
      await tester.tap(find.byKey(const Key('localSelectorTap')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('opcaoLocalizacaoAtual')));
      await tester.pumpAndSettle();

      // Salva
      await tester.tap(find.byKey(const Key('salvarBaseButton')));
      await tester.pump();

      final captured =
          verify(() => mockBloc.add(captureAny())).captured;
      expect(captured.last, isA<CriarBaseEvent>());

      final event = captured.last as CriarBaseEvent;
      expect(event.base.nome, 'Garagem SP');
      expect(event.base.local.enderecoTexto, 'Rua X, 100');
      expect(event.base.isPrincipal, isFalse);
    });

    testWidgets('deve incluir complemento no local quando preenchido',
        (tester) async {
      const tLocal = LocalGeo(
        enderecoTexto: 'Rua X, 100',
        latitude: -23.5,
        longitude: -46.6,
      );
      when(() => mockGeoService.obterLocalizacaoAtual())
          .thenAnswer((_) async => tLocal);

      await tester.pumpWidget(buildPage());

      await tester.enterText(
        find.byKey(const Key('baseNomeField')),
        'Garagem SP',
      );
      await tester.tap(find.byKey(const Key('localSelectorTap')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('opcaoLocalizacaoAtual')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('baseComplementoField')),
        'Galpão 3',
      );
      await tester.tap(find.byKey(const Key('salvarBaseButton')));
      await tester.pump();

      final captured =
          verify(() => mockBloc.add(captureAny())).captured;
      final event = captured.last as CriarBaseEvent;
      expect(event.base.local.complemento, 'Galpão 3');
    });
  });
}

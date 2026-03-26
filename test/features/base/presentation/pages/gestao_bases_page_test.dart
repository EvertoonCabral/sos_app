import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/entities/local_geo.dart';
import 'package:sos_app/features/base/domain/entities/base.dart';
import 'package:sos_app/features/base/presentation/bloc/base_bloc.dart';
import 'package:sos_app/features/base/presentation/bloc/base_event.dart';
import 'package:sos_app/features/base/presentation/bloc/base_state.dart';
import 'package:sos_app/features/base/presentation/pages/gestao_bases_page.dart';

class MockBaseBloc extends MockBloc<BaseEvent, BaseState> implements BaseBloc {}

void main() {
  late MockBaseBloc mockBloc;

  setUp(() {
    mockBloc = MockBaseBloc();
  });

  Widget buildPage() {
    return MaterialApp(
      home: BlocProvider<BaseBloc>.value(
        value: mockBloc,
        child: const GestaoBasesPage(),
      ),
    );
  }

  final tBases = [
    Base(
      id: 'base-001',
      nome: 'Garagem SP',
      local: const LocalGeo(
        enderecoTexto: 'Rua X, 100',
        latitude: -23.5,
        longitude: -46.6,
      ),
      isPrincipal: true,
      criadoEm: DateTime(2026, 3, 1),
    ),
    Base(
      id: 'base-002',
      nome: 'Garagem RJ',
      local: const LocalGeo(
        enderecoTexto: 'Rua Y, 200',
        latitude: -22.9,
        longitude: -43.2,
      ),
      criadoEm: DateTime(2026, 3, 2),
    ),
  ];

  group('GestaoBasesPage', () {
    testWidgets('deve exibir loading quando carregando', (tester) async {
      when(() => mockBloc.state).thenReturn(const BaseCarregando());
      await tester.pumpWidget(buildPage());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('deve exibir lista de bases com principal destacada',
        (tester) async {
      when(() => mockBloc.state).thenReturn(BaseListaCarregada(tBases));
      await tester.pumpWidget(buildPage());

      expect(find.text('Garagem SP'), findsOneWidget);
      expect(find.text('Garagem RJ'), findsOneWidget);
      // Principal tem chip
      expect(find.text('Principal'), findsOneWidget);
      // Não-principal tem botão "Definir"
      expect(find.text('Definir'), findsOneWidget);
    });

    testWidgets('deve exibir mensagem quando lista vazia', (tester) async {
      when(() => mockBloc.state).thenReturn(const BaseListaCarregada([]));
      await tester.pumpWidget(buildPage());

      expect(find.text('Nenhuma base cadastrada.'), findsOneWidget);
    });

    testWidgets('deve exibir mensagem de erro', (tester) async {
      when(() => mockBloc.state).thenReturn(const BaseErro('Erro de leitura'));
      await tester.pumpWidget(buildPage());

      expect(find.text('Erro de leitura'), findsOneWidget);
    });

    testWidgets('deve disparar DefinirBasePrincipalEvent ao clicar Definir',
        (tester) async {
      when(() => mockBloc.state).thenReturn(BaseListaCarregada(tBases));
      await tester.pumpWidget(buildPage());

      await tester.tap(find.byKey(const Key('setPrincipal_base-002')));
      await tester.pump();

      verify(
        () => mockBloc.add(const DefinirBasePrincipalEvent('base-002')),
      ).called(1);
    });

    testWidgets('deve exibir FAB de adicionar base', (tester) async {
      when(() => mockBloc.state).thenReturn(const BaseListaCarregada([]));
      await tester.pumpWidget(buildPage());

      expect(find.byKey(const Key('addBaseButton')), findsOneWidget);
    });
  });
}

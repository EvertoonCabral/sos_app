import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/entities/local_geo.dart';
import 'package:sos_app/features/atendimento/domain/entities/atendimento.dart';
import 'package:sos_app/features/atendimento/domain/entities/atendimento_enums.dart';
import 'package:sos_app/features/atendimento/presentation/bloc/atendimento_bloc.dart';
import 'package:sos_app/features/atendimento/presentation/bloc/atendimento_event.dart';
import 'package:sos_app/features/atendimento/presentation/bloc/atendimento_state.dart';
import 'package:sos_app/features/atendimento/presentation/pages/lista_atendimentos_page.dart';

class MockAtendimentoBloc extends MockBloc<AtendimentoEvent, AtendimentoState>
    implements AtendimentoBloc {}

void main() {
  late MockAtendimentoBloc mockBloc;

  const local = LocalGeo(
    enderecoTexto: 'Rua Teste, 100',
    latitude: -23.55,
    longitude: -46.63,
  );

  final tAtendimentos = [
    Atendimento(
      id: 'at-001',
      clienteId: 'c1',
      usuarioId: 'u1',
      pontoDeSaida: local,
      localDeColeta: const LocalGeo(
        enderecoTexto: 'Coleta A',
        latitude: -23.55,
        longitude: -46.63,
      ),
      localDeEntrega: const LocalGeo(
        enderecoTexto: 'Entrega B',
        latitude: -23.56,
        longitude: -46.64,
      ),
      localDeRetorno: local,
      distanciaEstimadaKm: 25.0,
      valorPorKm: 5.0,
      tipoValor: TipoValor.porKm,
      criadoEm: DateTime(2025),
      atualizadoEm: DateTime(2025),
    ),
  ];

  setUp(() {
    mockBloc = MockAtendimentoBloc();
  });

  Widget buildPage() {
    return MaterialApp(
      home: BlocProvider<AtendimentoBloc>.value(
        value: mockBloc,
        child: const ListaAtendimentosPage(),
      ),
    );
  }

  group('ListaAtendimentosPage', () {
    testWidgets('deve exibir loading quando carregando', (tester) async {
      when(() => mockBloc.state).thenReturn(const AtendimentoCarregando());
      await tester.pumpWidget(buildPage());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('deve exibir lista de atendimentos', (tester) async {
      when(() => mockBloc.state)
          .thenReturn(AtendimentoListaCarregada(tAtendimentos));
      await tester.pumpWidget(buildPage());

      expect(find.byKey(const Key('atendimentoTile_at-001')), findsOneWidget);
      expect(find.textContaining('25.0 km'), findsOneWidget);
    });

    testWidgets('deve exibir estado vazio com widget padronizado',
        (tester) async {
      when(() => mockBloc.state)
          .thenReturn(const AtendimentoListaCarregada([]));
      await tester.pumpWidget(buildPage());

      expect(find.text('Nenhum atendimento encontrado.'), findsOneWidget);
      expect(find.byIcon(Icons.local_shipping_outlined), findsOneWidget);
    });

    testWidgets('deve exibir erro com botão retry', (tester) async {
      when(() => mockBloc.state)
          .thenReturn(const AtendimentoErro('Falha ao carregar'));
      await tester.pumpWidget(buildPage());

      expect(find.text('Falha ao carregar'), findsOneWidget);
      expect(find.text('Tentar novamente'), findsOneWidget);
    });

    testWidgets('deve disparar retry ao clicar botão', (tester) async {
      when(() => mockBloc.state).thenReturn(const AtendimentoErro('Falha'));
      await tester.pumpWidget(buildPage());

      await tester.tap(find.byKey(const Key('retryButton')));
      await tester.pump();

      verify(
        () => mockBloc.add(const ListarAtendimentosEvent()),
      ).called(greaterThanOrEqualTo(1));
    });

    testWidgets('deve exibir FAB para novo atendimento', (tester) async {
      when(() => mockBloc.state)
          .thenReturn(const AtendimentoListaCarregada([]));
      await tester.pumpWidget(buildPage());

      expect(find.byKey(const Key('novoAtendimentoFab')), findsOneWidget);
    });

    testWidgets('deve exibir botão de filtro', (tester) async {
      when(() => mockBloc.state)
          .thenReturn(const AtendimentoListaCarregada([]));
      await tester.pumpWidget(buildPage());

      expect(find.byKey(const Key('filtroStatusButton')), findsOneWidget);
    });
  });
}

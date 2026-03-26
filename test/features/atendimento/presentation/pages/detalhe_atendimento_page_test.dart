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
import 'package:sos_app/features/atendimento/presentation/pages/detalhe_atendimento_page.dart';
import 'package:sos_app/features/rastreamento/presentation/bloc/rastreamento_bloc.dart';
import 'package:sos_app/features/rastreamento/presentation/bloc/rastreamento_event.dart';
import 'package:sos_app/features/rastreamento/presentation/bloc/rastreamento_state.dart';

class MockAtendimentoBloc extends MockBloc<AtendimentoEvent, AtendimentoState>
    implements AtendimentoBloc {}

class MockRastreamentoBloc
    extends MockBloc<RastreamentoEvent, RastreamentoState>
    implements RastreamentoBloc {}

void main() {
  late MockAtendimentoBloc mockBloc;
  late MockRastreamentoBloc mockRastrBloc;

  const local = LocalGeo(
    enderecoTexto: 'Rua X, 100',
    latitude: -23.55,
    longitude: -46.63,
  );

  final atendimentoBase = Atendimento(
    id: 'at-int-001',
    clienteId: 'c1',
    usuarioId: 'u1',
    pontoDeSaida: local,
    localDeColeta: local,
    localDeEntrega: local,
    localDeRetorno: local,
    distanciaEstimadaKm: 30.0,
    valorPorKm: 5.0,
    tipoValor: TipoValor.porKm,
    criadoEm: DateTime(2025),
    atualizadoEm: DateTime(2025),
  );

  setUp(() {
    mockBloc = MockAtendimentoBloc();
    mockRastrBloc = MockRastreamentoBloc();
    when(() => mockRastrBloc.state).thenReturn(const RastreamentoInicial());
  });

  Widget buildPage(Atendimento atendimento) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AtendimentoBloc>.value(value: mockBloc),
          BlocProvider<RastreamentoBloc>.value(value: mockRastrBloc),
        ],
        child: DetalheAtendimentoPage(atendimento: atendimento),
      ),
    );
  }

  group('Fluxo de transição de status — DetalheAtendimentoPage', () {
    testWidgets('deve exibir botões de avançar e cancelar para rascunho',
        (tester) async {
      when(() => mockBloc.state).thenReturn(const AtendimentoInicial());
      await tester.pumpWidget(buildPage(atendimentoBase));

      expect(find.byKey(const Key('avancarStatusButton')), findsOneWidget);
      expect(
          find.byKey(const Key('cancelarAtendimentoButton')), findsOneWidget);
      expect(find.text('Iniciar Deslocamento'), findsOneWidget);
    });

    testWidgets('deve exibir botão correto para emDeslocamento',
        (tester) async {
      final atEmDeslocamento = Atendimento(
        id: 'at-int-001',
        clienteId: 'c1',
        usuarioId: 'u1',
        pontoDeSaida: local,
        localDeColeta: local,
        localDeEntrega: local,
        localDeRetorno: local,
        distanciaEstimadaKm: 30.0,
        valorPorKm: 5.0,
        tipoValor: TipoValor.porKm,
        status: AtendimentoStatus.emDeslocamento,
        criadoEm: DateTime(2025),
        atualizadoEm: DateTime(2025),
      );

      when(() => mockBloc.state).thenReturn(const AtendimentoInicial());
      await tester.pumpWidget(buildPage(atEmDeslocamento));

      expect(find.text('Cheguei para Coleta'), findsOneWidget);
    });

    testWidgets('deve exibir informações de detalhe do atendimento',
        (tester) async {
      when(() => mockBloc.state).thenReturn(const AtendimentoInicial());
      await tester.pumpWidget(buildPage(atendimentoBase));

      expect(find.text('Ponto de Saída'), findsOneWidget);
      expect(find.text('Local de Coleta'), findsOneWidget);
      expect(find.text('Local de Entrega'), findsOneWidget);
      expect(find.text('Local de Retorno'), findsOneWidget);
      expect(find.textContaining('30.0 km'), findsOneWidget);
    });

    testWidgets('não deve exibir botões para atendimento concluído',
        (tester) async {
      final atConcluido = Atendimento(
        id: 'at-int-001',
        clienteId: 'c1',
        usuarioId: 'u1',
        pontoDeSaida: local,
        localDeColeta: local,
        localDeEntrega: local,
        localDeRetorno: local,
        distanciaEstimadaKm: 30.0,
        valorPorKm: 5.0,
        tipoValor: TipoValor.porKm,
        status: AtendimentoStatus.concluido,
        criadoEm: DateTime(2025),
        atualizadoEm: DateTime(2025),
      );

      when(() => mockBloc.state).thenReturn(const AtendimentoInicial());
      await tester.pumpWidget(buildPage(atConcluido));

      expect(find.byKey(const Key('avancarStatusButton')), findsNothing);
      expect(find.byKey(const Key('cancelarAtendimentoButton')), findsNothing);
    });

    testWidgets('deve disparar evento ao clicar avançar status',
        (tester) async {
      when(() => mockBloc.state).thenReturn(const AtendimentoInicial());
      await tester.pumpWidget(buildPage(atendimentoBase));

      await tester.tap(find.byKey(const Key('avancarStatusButton')));
      await tester.pump();

      verify(
        () => mockBloc.add(
          AtualizarStatusEvent(
            atendimento: atendimentoBase,
            novoStatus: AtendimentoStatus.emDeslocamento,
          ),
        ),
      ).called(1);
    });

    testWidgets('deve exibir SnackBar de erro quando AtendimentoErro',
        (tester) async {
      when(() => mockBloc.state).thenReturn(const AtendimentoInicial());
      whenListen(
        mockBloc,
        Stream.fromIterable([
          const AtendimentoErro('Falha ao atualizar status'),
        ]),
        initialState: const AtendimentoInicial(),
      );

      await tester.pumpWidget(buildPage(atendimentoBase));
      await tester.pumpAndSettle();

      expect(find.text('Falha ao atualizar status'), findsOneWidget);
    });

    testWidgets(
        'deve disparar IniciarRastreamentoEvent no initState ao abrir com emDeslocamento',
        (tester) async {
      final atEmDeslocamento = Atendimento(
        id: 'at-int-001',
        clienteId: 'c1',
        usuarioId: 'u1',
        pontoDeSaida: local,
        localDeColeta: local,
        localDeEntrega: local,
        localDeRetorno: local,
        distanciaEstimadaKm: 30.0,
        valorPorKm: 5.0,
        tipoValor: TipoValor.porKm,
        status: AtendimentoStatus.emDeslocamento,
        criadoEm: DateTime(2025),
        atualizadoEm: DateTime(2025),
      );

      when(() => mockBloc.state).thenReturn(const AtendimentoInicial());
      await tester.pumpWidget(buildPage(atEmDeslocamento));
      await tester.pump(); // allow postFrameCallback

      verify(
        () => mockRastrBloc.add(
          const IniciarRastreamentoEvent(atendimentoId: 'at-int-001'),
        ),
      ).called(1);
    });

    testWidgets(
        'deve disparar IniciarRastreamentoEvent quando status transiciona para emDeslocamento',
        (tester) async {
      when(() => mockBloc.state).thenReturn(const AtendimentoInicial());
      whenListen(
        mockBloc,
        Stream.fromIterable([
          AtendimentoStatusAtualizado(
            atendimentoBase.copyWith(status: AtendimentoStatus.emDeslocamento),
          ),
        ]),
        initialState: const AtendimentoInicial(),
      );

      await tester.pumpWidget(buildPage(atendimentoBase));
      await tester.pumpAndSettle();

      verify(
        () => mockRastrBloc.add(
          IniciarRastreamentoEvent(atendimentoId: atendimentoBase.id),
        ),
      ).called(1);
    });

    testWidgets(
        'deve disparar PararRastreamentoEvent quando status transiciona para concluido',
        (tester) async {
      when(() => mockBloc.state).thenReturn(const AtendimentoInicial());
      whenListen(
        mockBloc,
        Stream.fromIterable([
          AtendimentoStatusAtualizado(
            atendimentoBase.copyWith(status: AtendimentoStatus.concluido),
          ),
        ]),
        initialState: const AtendimentoInicial(),
      );

      await tester.pumpWidget(buildPage(atendimentoBase));
      await tester.pumpAndSettle();

      verify(
        () => mockRastrBloc.add(const PararRastreamentoEvent()),
      ).called(1);
    });
  });
}

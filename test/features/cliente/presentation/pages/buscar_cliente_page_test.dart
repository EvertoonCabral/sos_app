import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/features/cliente/domain/entities/cliente.dart';
import 'package:sos_app/features/cliente/presentation/bloc/cliente_bloc.dart';
import 'package:sos_app/features/cliente/presentation/bloc/cliente_event.dart';
import 'package:sos_app/features/cliente/presentation/bloc/cliente_state.dart';
import 'package:sos_app/features/cliente/presentation/pages/buscar_cliente_page.dart';

class MockClienteBloc extends MockBloc<ClienteEvent, ClienteState>
    implements ClienteBloc {}

void main() {
  late MockClienteBloc mockBloc;

  setUp(() {
    mockBloc = MockClienteBloc();
  });

  Widget buildPage() {
    return MaterialApp(
      home: BlocProvider<ClienteBloc>.value(
        value: mockBloc,
        child: const BuscarClientePage(),
      ),
    );
  }

  final tClientes = [
    Cliente(
      id: 'cli-001',
      nome: 'Maria Silva',
      telefone: '+5511988880000',
      criadoEm: DateTime(2026, 3, 1),
      atualizadoEm: DateTime(2026, 3, 1),
    ),
    Cliente(
      id: 'cli-002',
      nome: 'João Santos',
      telefone: '+5511977770000',
      criadoEm: DateTime(2026, 3, 2),
      atualizadoEm: DateTime(2026, 3, 2),
    ),
  ];

  group('BuscarClientePage', () {
    testWidgets('deve exibir campo de busca e botão FAB', (tester) async {
      when(() => mockBloc.state).thenReturn(const ClienteListaCarregada([]));
      await tester.pumpWidget(buildPage());

      expect(find.byKey(const Key('searchClienteField')), findsOneWidget);
      expect(find.byKey(const Key('addClienteButton')), findsOneWidget);
    });

    testWidgets('deve exibir loading quando estado é Carregando',
        (tester) async {
      when(() => mockBloc.state).thenReturn(const ClienteCarregando());
      await tester.pumpWidget(buildPage());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('deve exibir lista de clientes', (tester) async {
      when(() => mockBloc.state).thenReturn(ClienteListaCarregada(tClientes));
      await tester.pumpWidget(buildPage());

      expect(find.text('Maria Silva'), findsOneWidget);
      expect(find.text('João Santos'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(2));
    });

    testWidgets('deve exibir mensagem quando lista vazia', (tester) async {
      when(() => mockBloc.state).thenReturn(const ClienteListaCarregada([]));
      await tester.pumpWidget(buildPage());

      expect(find.text('Nenhum cliente encontrado.'), findsOneWidget);
    });

    testWidgets('deve exibir mensagem de erro', (tester) async {
      when(() => mockBloc.state)
          .thenReturn(const ClienteErro('Erro ao buscar'));
      await tester.pumpWidget(buildPage());

      expect(find.text('Erro ao buscar'), findsOneWidget);
    });

    testWidgets('deve adicionar BuscarClientesEvent ao digitar',
        (tester) async {
      when(() => mockBloc.state).thenReturn(const ClienteListaCarregada([]));
      await tester.pumpWidget(buildPage());

      await tester.enterText(
        find.byKey(const Key('searchClienteField')),
        'Maria',
      );
      await tester.pump();

      verify(() => mockBloc.add(const BuscarClientesEvent('Maria'))).called(1);
    });
  });
}

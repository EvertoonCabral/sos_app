import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/features/cliente/domain/entities/cliente.dart';
import 'package:sos_app/features/cliente/presentation/bloc/cliente_bloc.dart';
import 'package:sos_app/features/cliente/presentation/bloc/cliente_event.dart';
import 'package:sos_app/features/cliente/presentation/bloc/cliente_state.dart';
import 'package:sos_app/features/cliente/presentation/pages/form_cliente_page.dart';

class MockClienteBloc extends MockBloc<ClienteEvent, ClienteState>
    implements ClienteBloc {}

void main() {
  late MockClienteBloc mockBloc;

  setUp(() {
    mockBloc = MockClienteBloc();
    when(() => mockBloc.state).thenReturn(const ClienteInicial());
  });

  setUpAll(() {
    registerFallbackValue(
      Cliente(
        id: 'fb',
        nome: 'fb',
        telefone: '0',
        criadoEm: DateTime(2026),
        atualizadoEm: DateTime(2026),
      ),
    );
    registerFallbackValue(
      const CriarClienteEvent(nome: 'fb', telefone: '0'),
    );
  });

  Widget buildPage({Cliente? cliente}) {
    return MaterialApp(
      home: BlocProvider<ClienteBloc>.value(
        value: mockBloc,
        child: FormClientePage(cliente: cliente),
      ),
    );
  }

  group('FormClientePage — Modo Criar', () {
    testWidgets('deve exibir campos vazios e título "Novo Cliente"',
        (tester) async {
      await tester.pumpWidget(buildPage());

      expect(find.text('Novo Cliente'), findsOneWidget);
      expect(find.byKey(const Key('clienteNomeField')), findsOneWidget);
      expect(find.byKey(const Key('clienteTelefoneField')), findsOneWidget);
      expect(find.byKey(const Key('clienteDocumentoField')), findsOneWidget);
      expect(find.text('Criar Cliente'), findsOneWidget);
    });

    testWidgets('deve validar nome vazio', (tester) async {
      await tester.pumpWidget(buildPage());

      await tester.tap(find.byKey(const Key('salvarClienteButton')));
      await tester.pump();

      expect(find.text('Informe o nome'), findsOneWidget);
    });

    testWidgets('deve validar telefone vazio', (tester) async {
      await tester.pumpWidget(buildPage());

      await tester.enterText(
        find.byKey(const Key('clienteNomeField')),
        'Maria',
      );
      await tester.tap(find.byKey(const Key('salvarClienteButton')));
      await tester.pump();

      expect(find.text('Informe o telefone'), findsOneWidget);
    });

    testWidgets('deve adicionar CriarClienteEvent com dados preenchidos',
        (tester) async {
      await tester.pumpWidget(buildPage());

      await tester.enterText(
        find.byKey(const Key('clienteNomeField')),
        'Maria Silva',
      );
      await tester.enterText(
        find.byKey(const Key('clienteTelefoneField')),
        '+5511988880000',
      );
      await tester.tap(find.byKey(const Key('salvarClienteButton')));
      await tester.pump();

      verify(() => mockBloc.add(const CriarClienteEvent(
            nome: 'Maria Silva',
            telefone: '+5511988880000',
          ))).called(1);
    });
  });

  group('FormClientePage — Modo Editar', () {
    final tCliente = Cliente(
      id: 'cli-001',
      nome: 'Maria Silva',
      telefone: '+5511988880000',
      documento: '123.456.789-00',
      criadoEm: DateTime(2026, 3, 1),
      atualizadoEm: DateTime(2026, 3, 1),
    );

    testWidgets('deve exibir dados do cliente e título "Editar Cliente"',
        (tester) async {
      await tester.pumpWidget(buildPage(cliente: tCliente));

      expect(find.text('Editar Cliente'), findsOneWidget);
      expect(find.text('Maria Silva'), findsOneWidget);
      expect(find.text('+5511988880000'), findsOneWidget);
      expect(find.text('123.456.789-00'), findsOneWidget);
      expect(find.text('Salvar'), findsOneWidget);
    });

    testWidgets('deve adicionar AtualizarClienteEvent ao salvar',
        (tester) async {
      await tester.pumpWidget(buildPage(cliente: tCliente));

      // Altera o nome
      await tester.enterText(
        find.byKey(const Key('clienteNomeField')),
        'Maria S. Atualizada',
      );
      await tester.tap(find.byKey(const Key('salvarClienteButton')));
      await tester.pump();

      final captor = verify(
        () => mockBloc.add(captureAny()),
      ).captured;

      expect(captor.last, isA<AtualizarClienteEvent>());
      final evento = captor.last as AtualizarClienteEvent;
      expect(evento.cliente.nome, 'Maria S. Atualizada');
    });
  });
}

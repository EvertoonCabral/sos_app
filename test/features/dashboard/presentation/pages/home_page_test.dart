import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/features/auth/domain/entities/usuario.dart';
import 'package:sos_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sos_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:sos_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:sos_app/features/dashboard/presentation/pages/home_page.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  const tUsuario = Usuario(
    id: 'u-1',
    nome: 'João Operador',
    telefone: '+5511999990000',
    email: 'joao@test.com',
    role: UsuarioRole.operador,
    valorPorKmDefault: 5.0,
    criadoEm: null,
  );

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.state).thenReturn(const AuthAutenticado(tUsuario));
  });

  Widget buildPage() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const HomePage(),
      ),
    );
  }

  group('HomePage', () {
    testWidgets('deve exibir saudação com nome do usuário', (tester) async {
      await tester.pumpWidget(buildPage());

      expect(find.text('Bem-vindo, João Operador!'), findsOneWidget);
    });

    testWidgets('deve exibir 4 cards de menu', (tester) async {
      await tester.pumpWidget(buildPage());

      expect(find.byKey(const Key('menuDashboard')), findsOneWidget);
      expect(find.byKey(const Key('menuAtendimentos')), findsOneWidget);
      expect(find.byKey(const Key('menuClientes')), findsOneWidget);
      expect(find.byKey(const Key('menuBases')), findsOneWidget);
    });

    testWidgets('deve exibir textos dos cards', (tester) async {
      await tester.pumpWidget(buildPage());

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Atendimentos'), findsOneWidget);
      expect(find.text('Clientes'), findsOneWidget);
      expect(find.text('Bases / Garagens'), findsOneWidget);
    });

    testWidgets('deve exibir botão de logout', (tester) async {
      await tester.pumpWidget(buildPage());

      expect(find.byKey(const Key('logoutButton')), findsOneWidget);
    });

    testWidgets('deve disparar LogoutSolicitado ao clicar logout',
        (tester) async {
      await tester.pumpWidget(buildPage());

      await tester.tap(find.byKey(const Key('logoutButton')));
      await tester.pump();

      verify(() => mockAuthBloc.add(const LogoutSolicitado())).called(1);
    });

    testWidgets('deve exibir "Usuário" quando não autenticado', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthNaoAutenticado());
      await tester.pumpWidget(buildPage());

      expect(find.text('Bem-vindo, Usuário!'), findsOneWidget);
    });
  });
}

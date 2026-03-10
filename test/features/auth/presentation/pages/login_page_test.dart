import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sos_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:sos_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:sos_app/features/auth/presentation/pages/login_page.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class FakeAuthEvent extends Fake implements AuthEvent {}

class FakeAuthState extends Fake implements AuthState {}

void main() {
  late MockAuthBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeAuthEvent());
    registerFallbackValue(FakeAuthState());
  });

  setUp(() {
    mockBloc = MockAuthBloc();
    when(() => mockBloc.state).thenReturn(const AuthInicial());
  });

  Widget buildPage() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockBloc,
        child: const LoginPage(),
      ),
    );
  }

  group('LoginPage', () {
    testWidgets('deve exibir campos de email, senha e botão Entrar',
        (tester) async {
      await tester.pumpWidget(buildPage());

      expect(find.byKey(const Key('loginEmailField')), findsOneWidget);
      expect(find.byKey(const Key('loginSenhaField')), findsOneWidget);
      expect(find.byKey(const Key('loginButton')), findsOneWidget);
      expect(find.text('Entrar'), findsOneWidget);
      expect(find.text('GuinchoApp'), findsOneWidget);
    });

    testWidgets('deve mostrar validação ao clicar Entrar com campos vazios',
        (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      expect(find.text('Informe o email'), findsOneWidget);
      expect(find.text('Informe a senha'), findsOneWidget);
    });

    testWidgets(
        'deve adicionar LoginSolicitado ao bloc ao submeter form válido',
        (tester) async {
      await tester.pumpWidget(buildPage());

      await tester.enterText(
        find.byKey(const Key('loginEmailField')),
        'joao@guincho.com',
      );
      await tester.enterText(
        find.byKey(const Key('loginSenhaField')),
        'senha123',
      );
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      verify(
        () => mockBloc.add(
          const LoginSolicitado(email: 'joao@guincho.com', senha: 'senha123'),
        ),
      ).called(1);
    });

    testWidgets('deve mostrar CircularProgressIndicator quando AuthCarregando',
        (tester) async {
      when(() => mockBloc.state).thenReturn(const AuthCarregando());
      whenListen(
        mockBloc,
        Stream<AuthState>.value(const AuthCarregando()),
        initialState: const AuthCarregando(),
      );

      await tester.pumpWidget(buildPage());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('deve mostrar SnackBar quando AuthErro', (tester) async {
      whenListen(
        mockBloc,
        Stream<AuthState>.value(const AuthErro('Credenciais inválidas')),
        initialState: const AuthInicial(),
      );

      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      expect(find.text('Credenciais inválidas'), findsOneWidget);
    });
  });
}

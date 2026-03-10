import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/routing/auth_gate.dart';
import 'package:sos_app/features/auth/domain/entities/usuario.dart';
import 'package:sos_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sos_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:sos_app/features/auth/presentation/bloc/auth_state.dart';

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
  });

  Widget buildGate(AuthState initialState) {
    when(() => mockBloc.state).thenReturn(initialState);
    whenListen(
      mockBloc,
      Stream<AuthState>.value(initialState),
      initialState: initialState,
    );
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockBloc,
        child: const AuthGate(),
      ),
    );
  }

  group('AuthGate', () {
    testWidgets('deve exibir loading quando AuthInicial', (tester) async {
      await tester.pumpWidget(buildGate(const AuthInicial()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('deve exibir loading quando AuthCarregando', (tester) async {
      await tester.pumpWidget(buildGate(const AuthCarregando()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('deve exibir LoginPage quando AuthNaoAutenticado',
        (tester) async {
      await tester.pumpWidget(buildGate(const AuthNaoAutenticado()));
      await tester.pumpAndSettle();
      expect(find.text('GuinchoApp'), findsOneWidget);
      expect(find.text('Entrar'), findsOneWidget);
    });

    testWidgets('deve exibir HomePage quando AuthAutenticado', (tester) async {
      final usuario = Usuario(
        id: 'u1',
        nome: 'João',
        telefone: '11999',
        email: 'j@g.com',
        role: UsuarioRole.operador,
        valorPorKmDefault: 5.0,
        criadoEm: DateTime(2026, 1, 1),
      );
      await tester.pumpWidget(buildGate(AuthAutenticado(usuario)));
      await tester.pumpAndSettle();
      expect(find.text('Bem-vindo, João!'), findsOneWidget);
    });

    testWidgets('deve enviar SessaoVerificada ao iniciar', (tester) async {
      await tester.pumpWidget(buildGate(const AuthInicial()));
      verify(() => mockBloc.add(const SessaoVerificada())).called(1);
    });
  });
}

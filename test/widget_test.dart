import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/core/routing/auth_gate.dart';
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

  testWidgets('App mostra LoginPage quando não autenticado',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const AuthNaoAutenticado());
    whenListen(
      mockBloc,
      Stream<AuthState>.value(const AuthNaoAutenticado()),
      initialState: const AuthNaoAutenticado(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockBloc,
          child: const AuthGate(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('GuinchoApp'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}

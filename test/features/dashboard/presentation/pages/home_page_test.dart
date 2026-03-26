import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sos_app/features/auth/domain/entities/usuario.dart';
import 'package:sos_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sos_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:sos_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:sos_app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:sos_app/features/dashboard/domain/usecases/obter_km_por_cliente.dart';
import 'package:sos_app/features/dashboard/domain/usecases/obter_resumo_periodo.dart';
import 'package:sos_app/features/dashboard/domain/usecases/obter_tempo_por_etapa.dart';
import 'package:sos_app/features/dashboard/presentation/pages/home_page.dart';

import '../../../../helpers/mocks.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  final tUsuario = Usuario(
    id: 'u-1',
    nome: 'João Operador',
    telefone: '+5511999990000',
    email: 'joao@test.com',
    role: UsuarioRole.operador,
    valorPorKmDefault: 5.0,
    criadoEm: DateTime(2025),
  );

  setUp(() {
    final getIt = GetIt.instance;
    getIt.reset();
    getIt.registerFactory<ObterResumoPeriodo>(() => MockObterResumoPeriodo());
    getIt.registerFactory<ObterKmPorCliente>(() => MockObterKmPorCliente());
    getIt.registerFactory<ObterTempoPorEtapa>(() => MockObterTempoPorEtapa());
    getIt.registerFactory<DashboardRepository>(() => MockDashboardRepository());

    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.state).thenReturn(AuthAutenticado(tUsuario));
  });

  tearDown(() {
    GetIt.instance.reset();
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
      await tester.pump();

      expect(find.text('Olá, João Operador'), findsOneWidget);
    });

    testWidgets('deve exibir drawer com itens de menu', (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();

      // Open the drawer
      final scaffoldState = tester.firstState<ScaffoldState>(
        find.byType(Scaffold),
      );
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('appDrawer')), findsOneWidget);
      expect(find.byKey(const Key('menuDashboard')), findsOneWidget);
      expect(find.byKey(const Key('menuAtendimentos')), findsOneWidget);
      expect(find.byKey(const Key('menuClientes')), findsOneWidget);
      expect(find.byKey(const Key('menuBases')), findsOneWidget);
    });

    testWidgets('deve exibir textos dos menus no drawer', (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();

      final scaffoldState = tester.firstState<ScaffoldState>(
        find.byType(Scaffold),
      );
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Atendimentos'), findsOneWidget);
      expect(find.text('Clientes'), findsOneWidget);
      expect(find.text('Bases / Garagens'), findsOneWidget);
    });

    testWidgets('deve exibir nome e email no drawer', (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();

      final scaffoldState = tester.firstState<ScaffoldState>(
        find.byType(Scaffold),
      );
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('drawerUserName')), findsOneWidget);
      expect(find.text('João Operador'), findsWidgets);
      expect(find.byKey(const Key('drawerUserEmail')), findsOneWidget);
      expect(find.text('joao@test.com'), findsOneWidget);
    });

    testWidgets('deve exibir botão de logout', (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();

      expect(find.byKey(const Key('logoutButton')), findsOneWidget);
    });

    testWidgets('deve mostrar diálogo de confirmação ao clicar logout',
        (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();

      await tester.tap(find.byKey(const Key('logoutButton')));
      await tester.pumpAndSettle();

      expect(find.text('Sair do app'), findsOneWidget);
      expect(find.text('Tem certeza que deseja sair?'), findsOneWidget);
    });

    testWidgets('deve disparar LogoutSolicitado ao confirmar logout',
        (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();

      await tester.tap(find.byKey(const Key('logoutButton')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('confirmarLogoutButton')));
      await tester.pumpAndSettle();

      verify(() => mockAuthBloc.add(const LogoutSolicitado())).called(1);
    });

    testWidgets('não deve disparar LogoutSolicitado ao cancelar logout',
        (tester) async {
      await tester.pumpWidget(buildPage());
      await tester.pump();

      await tester.tap(find.byKey(const Key('logoutButton')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Não'));
      await tester.pumpAndSettle();

      verifyNever(() => mockAuthBloc.add(const LogoutSolicitado()));
    });

    testWidgets('deve exibir "Usuário" quando não autenticado', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthNaoAutenticado());
      await tester.pumpWidget(buildPage());
      await tester.pump();

      expect(find.text('Olá, Usuário'), findsOneWidget);
    });
  });
}

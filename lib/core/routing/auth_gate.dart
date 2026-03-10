import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/home_page.dart';

/// Widget raiz que decide qual página exibir com base no estado de autenticação.
/// Atua como route guard: se não autenticado, mostra LoginPage;
/// se autenticado, mostra HomePage.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const SessaoVerificada());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAutenticado) {
          return const HomePage();
        }
        if (state is AuthCarregando || state is AuthInicial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // AuthNaoAutenticado ou AuthErro → Login
        return const LoginPage();
      },
    );
  }
}

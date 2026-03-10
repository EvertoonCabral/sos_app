import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;
    final nomeUsuario =
        state is AuthAutenticado ? state.usuario.nome : 'Usuário';

    return Scaffold(
      appBar: AppBar(
        title: const Text('GuinchoApp'),
        actions: [
          IconButton(
            key: const Key('logoutButton'),
            icon: const Icon(Icons.logout),
            onPressed: () =>
                context.read<AuthBloc>().add(const LogoutSolicitado()),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Bem-vindo, $nomeUsuario!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

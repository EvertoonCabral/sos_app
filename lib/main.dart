import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/di/injection.dart';
import 'core/routing/auth_gate.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/autenticar_usuario.dart';
import 'features/auth/domain/usecases/obter_usuario_logado.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const GuinchoApp());
}

class GuinchoApp extends StatelessWidget {
  const GuinchoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(
        autenticarUsuario: GetIt.I<AutenticarUsuario>(),
        obterUsuarioLogado: GetIt.I<ObterUsuarioLogado>(),
        authRepository: GetIt.I<AuthRepository>(),
      ),
      child: MaterialApp(
        title: 'GuinchoApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        home: const AuthGate(),
      ),
    );
  }
}

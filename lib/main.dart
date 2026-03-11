import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/constants/app_config.dart';
import 'core/di/injection.dart';
import 'core/routing/auth_gate.dart';
import 'core/utils/app_bloc_observer.dart';
import 'core/utils/app_logger.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/autenticar_usuario.dart';
import 'features/auth/domain/usecases/obter_usuario_logado.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  final logger = AppLogger.instance;
  logger.info('App iniciado com flavor: ${AppConfig.instance.flavor.name}',
      tag: 'Main');

  Bloc.observer = AppBlocObserver();

  FlutterError.onError = (details) {
    logger.error(
      'FlutterError: ${details.exceptionAsString()}',
      tag: 'FlutterError',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  runZonedGuarded(
    () => runApp(const GuinchoApp()),
    (error, stackTrace) {
      logger.error(
        'Unhandled error: $error',
        tag: 'ZoneError',
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
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
        title: AppConfig.instance.appName,
        debugShowCheckedModeBanner: !AppConfig.instance.isProd,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        home: const AuthGate(),
      ),
    );
  }
}

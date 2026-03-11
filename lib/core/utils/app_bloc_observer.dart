import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_logger.dart';

/// BlocObserver global para logging de eventos, transições e erros.
class AppBlocObserver extends BlocObserver {
  final _logger = AppLogger.instance;

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _logger.error(
      'Bloc error in ${bloc.runtimeType}',
      tag: 'BlocObserver',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    _logger.debug(
      '${bloc.runtimeType}: ${transition.event.runtimeType} → ${transition.nextState.runtimeType}',
      tag: 'BlocObserver',
    );
    super.onTransition(bloc, transition);
  }
}

import 'dart:developer' as dev;

import '../constants/app_config.dart';

/// Níveis de log disponíveis.
enum LogLevel { debug, info, warning, error }

/// Serviço de logging estruturado da aplicação.
///
/// Em dev/staging loga via `dart:developer`.
/// Para produção, pode ser estendido para enviar para Sentry / Crashlytics
/// implementando um [LogOutput] personalizado.
class AppLogger {
  AppLogger._();

  static final AppLogger instance = AppLogger._();

  final List<LogOutput> _outputs = [_DeveloperLogOutput()];

  /// Adiciona um output (ex: Sentry, arquivo).
  void addOutput(LogOutput output) => _outputs.add(output);

  void debug(String message, {String? tag}) =>
      _log(LogLevel.debug, message, tag: tag);

  void info(String message, {String? tag}) =>
      _log(LogLevel.info, message, tag: tag);

  void warning(String message, {String? tag, Object? error}) =>
      _log(LogLevel.warning, message, tag: tag, error: error);

  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _log(LogLevel.error, message,
          tag: tag, error: error, stackTrace: stackTrace);

  void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Em prod, só loga warning e error
    if (AppConfig.instance.isProd &&
        level != LogLevel.warning &&
        level != LogLevel.error) {
      return;
    }

    final entry = LogEntry(
      level: level,
      message: message,
      tag: tag ?? 'App',
      error: error,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
    );

    for (final output in _outputs) {
      output.write(entry);
    }
  }
}

/// Entrada de log estruturada.
class LogEntry {
  const LogEntry({
    required this.level,
    required this.message,
    required this.tag,
    required this.timestamp,
    this.error,
    this.stackTrace,
  });

  final LogLevel level;
  final String message;
  final String tag;
  final DateTime timestamp;
  final Object? error;
  final StackTrace? stackTrace;
}

/// Interface para outputs de log.
abstract class LogOutput {
  void write(LogEntry entry);
}

/// Output padrão via dart:developer log.
class _DeveloperLogOutput implements LogOutput {
  @override
  void write(LogEntry entry) {
    final levelInt = switch (entry.level) {
      LogLevel.debug => 500,
      LogLevel.info => 800,
      LogLevel.warning => 900,
      LogLevel.error => 1000,
    };

    dev.log(
      '[${entry.level.name.toUpperCase()}] ${entry.message}',
      name: entry.tag,
      level: levelInt,
      error: entry.error,
      stackTrace: entry.stackTrace,
    );
  }
}

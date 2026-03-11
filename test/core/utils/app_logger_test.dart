import 'package:flutter_test/flutter_test.dart';

import 'package:sos_app/core/utils/app_logger.dart';

class _TestLogOutput implements LogOutput {
  final entries = <LogEntry>[];

  @override
  void write(LogEntry entry) => entries.add(entry);
}

void main() {
  group('AppLogger', () {
    test('deve registrar entradas de log via output customizado', () {
      final logger = AppLogger.instance;
      final testOutput = _TestLogOutput();
      logger.addOutput(testOutput);

      logger.info('Teste info', tag: 'Test');
      logger.warning('Teste warning', tag: 'Test');
      logger.error('Teste error', tag: 'Test', error: 'err');

      // No modo dev (padrão nos testes), deve logar tudo
      final infoEntries =
          testOutput.entries.where((e) => e.message == 'Teste info');
      expect(infoEntries, isNotEmpty);

      final warningEntries =
          testOutput.entries.where((e) => e.message == 'Teste warning');
      expect(warningEntries, isNotEmpty);

      final errorEntries =
          testOutput.entries.where((e) => e.message == 'Teste error');
      expect(errorEntries, isNotEmpty);
      expect(errorEntries.first.error, 'err');
    });

    test('LogEntry deve conter todos os campos', () {
      final entry = LogEntry(
        level: LogLevel.error,
        message: 'Falha',
        tag: 'DB',
        timestamp: DateTime(2025),
        error: Exception('test'),
        stackTrace: StackTrace.current,
      );

      expect(entry.level, LogLevel.error);
      expect(entry.message, 'Falha');
      expect(entry.tag, 'DB');
      expect(entry.error, isA<Exception>());
      expect(entry.stackTrace, isNotNull);
    });
  });
}

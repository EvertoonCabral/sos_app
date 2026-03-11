import 'package:flutter_test/flutter_test.dart';

import 'package:sos_app/core/constants/app_config.dart';

void main() {
  group('AppConfig', () {
    test('instance padrão (sem FLAVOR) deve ser dev', () {
      final config = AppConfig.instance;
      expect(config.flavor, Flavor.dev);
      expect(config.isDev, isTrue);
      expect(config.isProd, isFalse);
      expect(config.isStaging, isFalse);
      expect(config.enableLogging, isTrue);
    });

    test('appName deve conter [DEV] no modo dev', () {
      final config = AppConfig.instance;
      expect(config.appName, contains('[DEV]'));
    });

    test('apiBaseUrl deve apontar para localhost no modo dev', () {
      final config = AppConfig.instance;
      expect(config.apiBaseUrl, contains('10.0.2.2'));
    });
  });
}

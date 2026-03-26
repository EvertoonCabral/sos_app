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

    test(
        'apiBaseUrl deve usar endpoint HTTP(S) configurado com prefixo /api no modo dev',
        () {
      final config = AppConfig.instance;
      final uri = Uri.parse(config.apiBaseUrl);

      expect(uri.hasScheme, isTrue);
      expect(uri.scheme == 'http' || uri.scheme == 'https', isTrue);
      expect(uri.path, '/api');
    });
  });
}

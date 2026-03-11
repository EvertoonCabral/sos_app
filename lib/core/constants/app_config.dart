/// Configuração de ambiente (flavor) da aplicação.
///
/// Utilizar via `--dart-define=FLAVOR=dev|staging|prod`:
/// ```bash
/// flutter run --dart-define=FLAVOR=dev
/// flutter build apk --dart-define=FLAVOR=prod
/// ```
enum Flavor { dev, staging, prod }

class AppConfig {
  const AppConfig._({
    required this.flavor,
    required this.apiBaseUrl,
    required this.appName,
    required this.enableLogging,
  });

  final Flavor flavor;
  final String apiBaseUrl;
  final String appName;
  final bool enableLogging;

  static const _flavorStr =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  static final AppConfig instance = _fromFlavor(_flavorStr);

  static AppConfig _fromFlavor(String f) {
    switch (f) {
      case 'prod':
        return const AppConfig._(
          flavor: Flavor.prod,
          apiBaseUrl: 'https://api.guinchoapp.com.br',
          appName: 'GuinchoApp',
          enableLogging: false,
        );
      case 'staging':
        return const AppConfig._(
          flavor: Flavor.staging,
          apiBaseUrl: 'https://staging-api.guinchoapp.com.br',
          appName: 'GuinchoApp [STG]',
          enableLogging: true,
        );
      default:
        return const AppConfig._(
          flavor: Flavor.dev,
          apiBaseUrl: 'http://10.0.2.2:3000',
          appName: 'GuinchoApp [DEV]',
          enableLogging: true,
        );
    }
  }

  bool get isDev => flavor == Flavor.dev;
  bool get isStaging => flavor == Flavor.staging;
  bool get isProd => flavor == Flavor.prod;
}

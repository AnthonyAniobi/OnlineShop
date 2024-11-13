enum AppEnvironment { DEV, STAGING, PROD }

abstract class EnvInfo {
  static AppEnvironment _environment = AppEnvironment.DEV;

  static void initialize(AppEnvironment environment) {
    EnvInfo._environment = environment;
  }

  static String get baseUrl => _environment._baseUrl;
  static String get envName => _environment._envName;
  static AppEnvironment get environment => _environment;
  static bool get isProduction => _environment == AppEnvironment.PROD;
}

extension _EnvProperties on AppEnvironment {
  static const _urls = {
    AppEnvironment.DEV: 'https://api.escuelajs.co/api/v1',
    AppEnvironment.STAGING: 'https://api.escuelajs.co/api/v1',
    AppEnvironment.PROD: 'https://api.escuelajs.co/api/v1',
  };

  static const _envs = {
    AppEnvironment.DEV: 'dev',
    AppEnvironment.STAGING: 'staging',
    AppEnvironment.PROD: 'prod',
  };

  String get _envName => _envs[this]!;
  String get _baseUrl => _urls[this]!;
}

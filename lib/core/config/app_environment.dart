enum AppEnvironment { dev, staging, prod }

class AppEnvironmentConfig {
  const AppEnvironmentConfig._();

  static const String envName = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  /// Temporary toggle for non-auth features that may still need mocks.
  static const bool useMockApi = bool.fromEnvironment(
    'USE_MOCK_API',
    defaultValue: false,
  );

  static AppEnvironment get current {
    switch (envName) {
      case 'prod':
        return AppEnvironment.prod;
      case 'staging':
        return AppEnvironment.staging;
      default:
        return AppEnvironment.dev;
    }
  }
}

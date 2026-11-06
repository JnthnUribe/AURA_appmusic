import 'package:flutter/foundation.dart';

/// Build-time configuration. Flavors are selected with
/// `--dart-define-from-file=env/dev.json` (see `app/env/`).
@immutable
class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.environment,
    this.enableDevGallery = false,
  });

  factory AppConfig.fromEnvironment() {
    const baseUrl = String.fromEnvironment(
      'AURA_API_BASE_URL',
      defaultValue: 'http://localhost:8000',
    );
    const environment = String.fromEnvironment('AURA_ENV', defaultValue: 'dev');
    const gallery = bool.fromEnvironment('AURA_DEV_GALLERY');
    return AppConfig(
      apiBaseUrl: baseUrl.endsWith('/')
          ? baseUrl.substring(0, baseUrl.length - 1)
          : baseUrl,
      environment: environment,
      enableDevGallery: gallery || environment == 'dev',
    );
  }

  final String apiBaseUrl;
  final String environment;
  final bool enableDevGallery;

  bool get isProduction => environment == 'prod';

  @override
  String toString() => 'AppConfig($environment, $apiBaseUrl)';
}

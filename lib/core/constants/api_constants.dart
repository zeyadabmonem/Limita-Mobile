/// Network-related constants shared across the app.
abstract class ApiConstants {
  const ApiConstants._();

  /// Base URL of the Limita backend API.
  static const String baseUrl = 'https://limita.runasp.net';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 20);

  static const String contentType = 'application/json';

  // Header keys
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer';
  static const String acceptLanguageHeader = 'Accept-Language';
}

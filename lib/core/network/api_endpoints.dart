/// All backend endpoint paths, relative to [ApiConstants.baseUrl].
/// Keep every literal route string here — nowhere else.
abstract class ApiEndpoints {
  const ApiEndpoints._();

  // Auth
  static const String login = '/api/Auth/login';
  static const String register = '/api/Auth/register';
  static const String refreshToken = '/api/Auth/refresh-token';
  static const String logout = '/api/Auth/logout';
}

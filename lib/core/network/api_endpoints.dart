/// All backend endpoint paths, relative to [ApiConstants.baseUrl].
/// Keep every literal route string here — nowhere else.
abstract class ApiEndpoints {
  const ApiEndpoints._();

  // Auth
  static const String login = '/api/v1/auth/login';
  static const String register = '/api/v1/auth/register';
  static const String changePassword = '/api/v1/auth/change-password';
}

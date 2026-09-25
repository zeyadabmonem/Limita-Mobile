/// Centralized, non-localized strings.
/// Kept as a single source of truth so it's easy to swap for a real
/// localization solution (e.g. easy_localization / intl) later on.
abstract class AppStrings {
  const AppStrings._();

  static const String appName = 'Limita';

  // Generic
  static const String genericError = 'Something went wrong. Please try again.';
  static const String noInternetConnection =
      'No internet connection. Please check your network.';
  static const String requestTimeout = 'The request timed out. Please try again.';
  static const String unauthorized = 'Your session has expired. Please sign in again.';
  static const String serverError = 'Server error. Please try again later.';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String ok = 'OK';

  // Auth
  static const String login = 'Login';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String loginButton = 'Sign In';
}

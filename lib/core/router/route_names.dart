/// Centralized route paths & names for GoRouter.
/// Never hardcode a route string inside a feature — reference it from here.
abstract class RouteNames {
  const RouteNames._();

  static const String splash = 'splash';
  static const String login = 'login';
  static const String home = 'home';
}

abstract class RoutePaths {
  const RoutePaths._();

  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
}

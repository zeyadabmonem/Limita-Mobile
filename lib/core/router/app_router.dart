import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../storage/token_storage.dart';
import 'route_names.dart';

/// Builds the app's [GoRouter]. Auth-gating lives in [redirect] so no
/// individual page needs to know how routing/session logic works.
class AppRouter {
  AppRouter(this._tokenStorage);

  final TokenStorage _tokenStorage;

  late final GoRouter router = GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
    redirect: (context, state) async {
      final bool isLoggedIn = await _tokenStorage.hasValidSession();
      final bool goingToSplash = state.matchedLocation == RoutePaths.splash;
      final bool goingToLogin = state.matchedLocation == RoutePaths.login;

      // Let the splash screen own the very first redirect decision.
      if (goingToSplash) return null;

      if (!isLoggedIn && !goingToLogin) return RoutePaths.login;
      if (isLoggedIn && goingToLogin) return RoutePaths.home;

      return null;
    },
  );
}

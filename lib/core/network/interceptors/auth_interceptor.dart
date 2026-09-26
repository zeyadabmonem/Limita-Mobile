import 'package:dio/dio.dart';

import '../../constants/api_constants.dart';
import '../../storage/token_storage.dart';

/// Attaches `Authorization: Bearer <token>` to every outgoing request
/// that isn't explicitly marked as public (e.g. login/register).
///
/// A request can opt out via:
/// ```dart
/// dio.get(path, options: Options(extra: {'requiresAuth': false}));
/// ```
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage);

  final TokenStorage _tokenStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final bool requiresAuth = options.extra['requiresAuth'] as bool? ?? true;

    if (requiresAuth) {
      final String? token = await _tokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers[ApiConstants.authorizationHeader] =
            '${ApiConstants.bearerPrefix} $token';
      }
    }

    handler.next(options);
  }
}

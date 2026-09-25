import 'secure_storage_service.dart';

/// Persists and retrieves the JWT access/refresh tokens.
///
/// This is the single source of truth for "is the user logged in" and for
/// where a token physically lives — nothing else in the app should touch
/// secure storage directly for auth data.
class TokenStorage {
  TokenStorage(this._secureStorage);

  final SecureStorageService _secureStorage;

  static const String _accessTokenKey = 'ACCESS_TOKEN';
  static const String _refreshTokenKey = 'REFRESH_TOKEN';

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _secureStorage.write(_accessTokenKey, accessToken);
    if (refreshToken != null) {
      await _secureStorage.write(_refreshTokenKey, refreshToken);
    }
  }

  Future<String?> getAccessToken() => _secureStorage.read(_accessTokenKey);

  Future<String?> getRefreshToken() => _secureStorage.read(_refreshTokenKey);

  Future<bool> hasValidSession() async {
    final String? token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clear() async {
    await _secureStorage.delete(_accessTokenKey);
    await _secureStorage.delete(_refreshTokenKey);
  }
}

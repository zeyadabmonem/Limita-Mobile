import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/api_constants.dart';
import '../error/exceptions.dart';
import '../storage/token_storage.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';

/// Thin wrapper around [Dio] that is the single entry point for every
/// HTTP call in the app.
///
/// - Applies the shared base URL / timeouts / headers.
/// - Attaches the JWT via [AuthInterceptor].
/// - Normalizes every failure into our own exception types via
///   [ErrorInterceptor], so callers only ever catch [ServerException],
///   [NetworkException], [TimeoutException] or [UnauthorizedException].
class ApiClient {
  ApiClient({
    required TokenStorage tokenStorage,
    Dio? dio,
    void Function()? onUnauthorized,
  })  : _tokenStorage = tokenStorage,
        _dio = dio ?? Dio() {
    _dio.options
      ..baseUrl = ApiConstants.baseUrl
      ..connectTimeout = ApiConstants.connectTimeout
      ..receiveTimeout = ApiConstants.receiveTimeout
      ..sendTimeout = ApiConstants.sendTimeout
      ..headers = {
        'Content-Type': ApiConstants.contentType,
        'Accept': ApiConstants.contentType,
      };

    _dio.interceptors.addAll([
      AuthInterceptor(_tokenStorage),
      ErrorInterceptor(onUnauthorized: onUnauthorized),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          compact: true,
        ),
    ]);
  }

  final Dio _dio;
  final TokenStorage _tokenStorage;

  /// Escape hatch for the rare case a feature needs the raw Dio instance
  /// (e.g. file upload with custom progress handling).
  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) {
    return _guard(() => _dio.get<T>(
          path,
          queryParameters: queryParameters,
          options: _withAuthFlag(options, requiresAuth),
        ));
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) {
    return _guard(() => _dio.post<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: _withAuthFlag(options, requiresAuth),
        ));
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) {
    return _guard(() => _dio.put<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: _withAuthFlag(options, requiresAuth),
        ));
  }

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) {
    return _guard(() => _dio.patch<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: _withAuthFlag(options, requiresAuth),
        ));
  }

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) {
    return _guard(() => _dio.delete<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: _withAuthFlag(options, requiresAuth),
        ));
  }

  Options _withAuthFlag(Options? options, bool requiresAuth) {
    final Options result = options ?? Options();
    result.extra = {...?result.extra, 'requiresAuth': requiresAuth};
    return result;
  }

  /// Runs a Dio call and re-throws the *mapped* exception set by
  /// [ErrorInterceptor] rather than the raw [DioException].
  Future<Response<T>> _guard<T>(Future<Response<T>> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      final Object? mapped = e.error;
      if (mapped is Exception) throw mapped;
      throw const ServerException('Unexpected network error.');
    }
  }
}

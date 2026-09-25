import 'package:dio/dio.dart';

import '../../error/exceptions.dart';

/// Converts every [DioException] into one of our own typed exceptions,
/// so the rest of the app never has to know about Dio.
///
/// [onUnauthorized] is invoked (without blocking the error propagation)
/// whenever a 401 is received, so the app can clear tokens / route to
/// the login screen from a single place.
class ErrorInterceptor extends Interceptor {
  ErrorInterceptor({this.onUnauthorized});

  final void Function()? onUnauthorized;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final Exception mapped = _mapDioException(err);
    handler.next(
      err.copyWith(error: mapped),
    );
  }

  Exception _mapDioException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.badCertificate:
        return const NetworkException('Secure connection could not be established.');

      case DioExceptionType.cancel:
        return const NetworkException('Request was cancelled.');

      case DioExceptionType.badResponse:
        return _mapBadResponse(err);

      case DioExceptionType.unknown:
        return const NetworkException();
    }
  }

  Exception _mapBadResponse(DioException err) {
    final int? statusCode = err.response?.statusCode;
    final dynamic data = err.response?.data;

    final String message = _extractMessage(data) ??
        'Request failed with status code $statusCode.';

    if (statusCode == 401) {
      onUnauthorized?.call();
      return UnauthorizedException(message);
    }

    Map<String, List<String>>? fieldErrors;
    if (data is Map<String, dynamic>) {
      final dynamic errors = data['errors'];
      if (errors is Map<String, dynamic>) {
        fieldErrors = errors.map(
          (key, value) => MapEntry(
            key,
            (value as List<dynamic>).map((e) => e.toString()).toList(),
          ),
        );
      }
    }

    return ServerException(message, statusCode: statusCode, fieldErrors: fieldErrors);
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final dynamic message = data['message'] ?? data['title'] ?? data['detail'];
      if (message is String && message.isNotEmpty) return message;
    }
    if (data is String && data.isNotEmpty) return data;
    return null;
  }
}

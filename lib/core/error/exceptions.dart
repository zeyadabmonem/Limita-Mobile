/// Exceptions thrown by the data layer (API client, datasources, local
/// storage). Repositories catch these and map them to a [Failure].
class ServerException implements Exception {
  const ServerException(this.message, {this.statusCode, this.fieldErrors});

  final String message;
  final int? statusCode;
  final Map<String, List<String>>? fieldErrors;

  @override
  String toString() => 'ServerException($statusCode): $message';
}

class NetworkException implements Exception {
  const NetworkException([this.message = 'No internet connection.']);

  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

class TimeoutException implements Exception {
  const TimeoutException([this.message = 'The request timed out.']);

  final String message;

  @override
  String toString() => 'TimeoutException: $message';
}

class UnauthorizedException implements Exception {
  const UnauthorizedException([this.message = 'Unauthorized.']);

  final String message;

  @override
  String toString() => 'UnauthorizedException: $message';
}

class CacheException implements Exception {
  const CacheException([this.message = 'Local storage error.']);

  final String message;

  @override
  String toString() => 'CacheException: $message';
}

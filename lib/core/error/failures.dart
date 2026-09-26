import 'package:equatable/equatable.dart';

/// Base class for all domain-layer failures.
///
/// Data sources throw [Exception]s (see `exceptions.dart`); repositories
/// catch them and convert them into a [Failure] so the rest of the app
/// (use cases, blocs, UI) never deals with raw exceptions.
abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// No internet / DNS / socket-level failure.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

/// The request took too long to complete.
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'The request timed out.']);
}

/// Non-2xx response from the server, carries the HTTP status code when known.
class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});

  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// 401 / invalid or expired token.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(
      [super.message = 'Session expired. Please sign in again.']);
}

/// 422 / 400 style validation errors, optionally with field-level detail.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.fieldErrors});

  final Map<String, List<String>>? fieldErrors;

  @override
  List<Object?> get props => [message, fieldErrors];
}

/// Failure reading/writing local/secure storage.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error.']);
}

/// Anything that doesn't fit the categories above.
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong.']);
}

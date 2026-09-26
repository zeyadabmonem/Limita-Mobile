import 'package:equatable/equatable.dart';

/// Domain-layer representation of the signed-in user.
/// Contains only what the app's business logic needs — never a raw DTO.
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
  });

  final String id;
  final String email;
  final String fullName;

  @override
  List<Object?> get props => [id, email, fullName];
}

/// Result of a successful authentication: the user plus their tokens.
class AuthSessionEntity extends Equatable {
  const AuthSessionEntity({
    required this.user,
    required this.accessToken,
    this.refreshToken,
  });

  final UserEntity user;
  final String accessToken;
  final String? refreshToken;

  @override
  List<Object?> get props => [user, accessToken, refreshToken];
}

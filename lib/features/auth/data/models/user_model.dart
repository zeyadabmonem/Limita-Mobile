import '../../../../core/error/exceptions.dart';
import '../../domain/entities/user_entity.dart';

/// Data-layer DTO for the user object returned by the API.
/// Converts to/from JSON and maps to [UserEntity] for the domain layer.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? json['userId'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      fullName: (json['fullName'] ?? json['name'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'fullName': fullName,
      };
}

/// DTO for the full `/auth/login` response payload.
class AuthResponseModel {
  const AuthResponseModel({
    required this.user,
    required this.accessToken,
    this.refreshToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json,
      {required String email}) {
    final Map<String, dynamic>? userJson =
        json['user'] as Map<String, dynamic>?;
    final token = json['token']?.toString() ?? '';
    if (token.isEmpty) {
      throw const ServerException('The sign-in response was invalid.');
    }

    return AuthResponseModel(
      user: UserModel.fromJson({...?userJson, ...json, 'email': email}),
      accessToken: token,
    );
  }

  final UserModel user;
  final String accessToken;
  final String? refreshToken;

  AuthSessionEntity toEntity() => AuthSessionEntity(
        user: user,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
}

/// DTO returned by `POST /api/v1/auth/register`. Registration deliberately
/// does not return a JWT, so it must not be treated as a logged-in session.
class RegisteredUserModel extends UserModel {
  const RegisteredUserModel({
    required super.id,
    required super.email,
    required super.fullName,
  });

  factory RegisteredUserModel.fromJson(Map<String, dynamic> json) =>
      RegisteredUserModel(
        id: json['id'].toString(),
        email: json['email'].toString(),
        fullName: json['fullName'].toString(),
      );
}

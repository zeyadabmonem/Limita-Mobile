import 'package:equatable/equatable.dart';

import '../../../../core/network/api_result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginParams extends Equatable {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class LoginUseCase implements UseCase<AuthSessionEntity, LoginParams> {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  ApiResult<AuthSessionEntity> call(LoginParams params) {
    return _repository.login(email: params.email, password: params.password);
  }
}

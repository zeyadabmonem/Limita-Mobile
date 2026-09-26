import '../../../../core/network/api_result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  RegisterUseCase(this._repository);

  final AuthRepository _repository;

  @override
  ApiResult<UserEntity> call(RegisterParams params) => _repository.register(
        fullName: params.fullName,
        email: params.email,
        phoneNumber: params.phoneNumber,
        password: params.password,
      );
}

class RegisterParams {
  const RegisterParams({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
}

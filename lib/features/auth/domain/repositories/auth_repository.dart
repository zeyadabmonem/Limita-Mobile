import '../../../../core/network/api_result.dart';
import '../entities/user_entity.dart';

/// Contract the domain layer depends on. The data layer provides the
/// concrete implementation ([AuthRepositoryImpl]); use cases and blocs
/// only ever see this interface.
abstract class AuthRepository {
  ApiResult<AuthSessionEntity> login({
    required String email,
    required String password,
  });

  ApiResult<void> logout();
}

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/storage/token_storage.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required TokenStorage tokenStorage,
  })  : _remoteDataSource = remoteDataSource,
        _tokenStorage = tokenStorage;

  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;

  @override
  ApiResult<AuthSessionEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final response =
          await _remoteDataSource.login(email: email, password: password);

      await _tokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      return Right(response.toEntity());
    } on UnauthorizedException {
      return const Left(UnauthorizedFailure('Invalid email or password.'));
    } on ServerException catch (e) {
      return Left(
        e.statusCode == 422 || e.statusCode == 400
            ? ValidationFailure(e.message, fieldErrors: e.fieldErrors)
            : ServerFailure(e.message, statusCode: e.statusCode),
      );
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  ApiResult<UserEntity> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.register(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );
      return Right(user);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(
        e.statusCode == 422 || e.statusCode == 400
            ? ValidationFailure(e.message, fieldErrors: e.fieldErrors)
            : ServerFailure(e.message, statusCode: e.statusCode),
      );
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure('Unable to create your account.'));
    }
  }

  @override
  ApiResult<void> logout() async {
    try {
      await _tokenStorage.clear();
      return const Right(null);
    } on Exception catch (_) {
      // Even if the network call fails, don't strand the user logged in.
      await _tokenStorage.clear();
      return const Right(null);
    }
  }
}

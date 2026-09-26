import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:limita_mobile/core/error/failures.dart';
import 'package:limita_mobile/core/network/api_result.dart';
import 'package:limita_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:limita_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:limita_mobile/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late LoginUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginUseCase(repository);
  });

  const email = 'user@limita.com';
  const password = 'P@ssw0rd';
  const session = AuthSessionEntity(
    user: UserEntity(id: '1', email: email, fullName: 'Test User'),
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
  );

  test('delegates to AuthRepository.login with the given credentials',
      () async {
    when(() => repository.login(email: email, password: password)).thenAnswer(
        (_) async => const Right<Failure, AuthSessionEntity>(session));

    final ApiResult<AuthSessionEntity> result =
        useCase(const LoginParams(email: email, password: password));

    final Either<Failure, AuthSessionEntity> either = await result;

    expect(either, const Right<Failure, AuthSessionEntity>(session));
    verify(() => repository.login(email: email, password: password)).called(1);
  });
}

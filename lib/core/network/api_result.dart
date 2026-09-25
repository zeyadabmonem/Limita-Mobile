import 'package:dartz/dartz.dart';

import '../error/failures.dart';

/// Standard return type for every repository method in the app:
/// `Left(Failure)` on error, `Right(T)` on success.
typedef ApiResult<T> = Future<Either<Failure, T>>;

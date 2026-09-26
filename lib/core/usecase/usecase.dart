import 'package:equatable/equatable.dart';

import '../network/api_result.dart';

/// Base contract for a use case that takes [Params] and returns [Result].
abstract class UseCase<Result, Params> {
  ApiResult<Result> call(Params params);
}

/// Base contract for a use case that takes no parameters.
abstract class NoParamsUseCase<Result> {
  ApiResult<Result> call();
}

/// Use for use cases that genuinely take no arguments, to keep a
/// consistent `call(params)` signature via [UseCase] if preferred over
/// [NoParamsUseCase].
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

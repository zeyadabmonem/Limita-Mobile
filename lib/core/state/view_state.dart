import 'package:equatable/equatable.dart';

import '../error/failures.dart';

/// Generic state for any async operation (an API call, a cache read...).
///
/// Every feature bloc/cubit should model its "data" state as
/// `ViewState<T>` instead of hand-rolling its own loading/error/success
/// flags, so loading & error handling look and behave the same across
/// the whole app.
sealed class ViewState<T> extends Equatable {
  const ViewState();

  @override
  List<Object?> get props => [];
}

class ViewInitial<T> extends ViewState<T> {
  const ViewInitial();
}

class ViewLoading<T> extends ViewState<T> {
  const ViewLoading();
}

/// Emitted while a subsequent action refreshes already-loaded data
/// (e.g. pull-to-refresh), so the UI can keep showing [data] while a
/// small inline spinner runs, instead of blanking the whole screen.
class ViewRefreshing<T> extends ViewState<T> {
  const ViewRefreshing(this.data);

  final T data;

  @override
  List<Object?> get props => [data];
}

class ViewSuccess<T> extends ViewState<T> {
  const ViewSuccess(this.data);

  final T data;

  @override
  List<Object?> get props => [data];
}

class ViewError<T> extends ViewState<T> {
  const ViewError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

/// Small helper so widgets can pattern-match without a giant switch
/// everywhere.
extension ViewStateX<T> on ViewState<T> {
  bool get isLoading => this is ViewLoading<T> || this is ViewRefreshing<T>;

  T? get dataOrNull => switch (this) {
        ViewSuccess<T>(:final data) => data,
        ViewRefreshing<T>(:final data) => data,
        _ => null,
      };

  Failure? get failureOrNull => switch (this) {
        ViewError<T>(:final failure) => failure,
        _ => null,
      };
}

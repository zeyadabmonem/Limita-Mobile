part of 'auth_bloc.dart';

/// The auth feature's state is just the shared [ViewState] applied to
/// [AuthSessionEntity] — this is what "loading state foundation" buys
/// every feature: no bespoke loading/error booleans per bloc.
typedef AuthState = ViewState<AuthSessionEntity>;

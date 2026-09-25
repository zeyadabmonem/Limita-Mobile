import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/state/view_state.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required TokenStorage tokenStorage,
  })  : _loginUseCase = loginUseCase,
        _tokenStorage = tokenStorage,
        super(const ViewInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  final LoginUseCase _loginUseCase;
  final TokenStorage _tokenStorage;

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const ViewLoading());

    final result = await _loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(ViewError(failure)),
      (session) => emit(ViewSuccess(session)),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _tokenStorage.clear();
    emit(const ViewInitial());
  }
}

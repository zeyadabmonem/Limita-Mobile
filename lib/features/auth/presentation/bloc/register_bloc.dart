import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/state/view_state.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/register_usecase.dart';

class RegisterBloc extends Cubit<ViewState<UserEntity>> {
  RegisterBloc(this._registerUseCase) : super(const ViewInitial());

  final RegisterUseCase _registerUseCase;

  Future<void> register(RegisterParams params) async {
    emit(const ViewLoading());
    final result = await _registerUseCase(params);
    result.fold((failure) => emit(ViewError(failure)),
        (user) => emit(ViewSuccess(user)));
  }
}

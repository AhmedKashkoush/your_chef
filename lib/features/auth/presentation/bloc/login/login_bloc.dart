import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/auth/domain/entities/user.dart';
import 'package:your_chef/features/auth/domain/usecases/login_usecase.dart';

import '../../../../../core/errors/failures.dart';

part 'login_events.dart';
part 'login_states.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  LoginBloc(this.loginUseCase) : super(const LoginInitialState()) {
    on<LoginSubmitEvent>(_login);
  }

  FutureOr<void> _login(
      LoginSubmitEvent event, Emitter<LoginState> emit) async {
    emit(const LoginLoadingState());
    final Either<Failure, User> result = await loginUseCase.call(event.options);

    result.fold((failure) {
      emit(LoginErrorState(failure.message));
    }, (user) {
      emit(LoginSuccessState(user));
    });
  }
}

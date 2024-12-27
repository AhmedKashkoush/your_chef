import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/auth/domain/entities/saved_user.dart';
import 'package:your_chef/features/auth/domain/usecases/auth/google_sign_in_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/auth/login_usecase.dart';

import '../../../../../core/errors/failures.dart';

part 'login_events.dart';
part 'login_states.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final GoogleSignUseCase googleSignUseCase;
  LoginBloc(this.loginUseCase, this.googleSignUseCase)
      : super(const LoginInitialState()) {
    on<LoginSubmitEvent>(_login);
    on<GoogleSignInEvent>(_googleSign);
  }

  FutureOr<void> _login(
      LoginSubmitEvent event, Emitter<LoginState> emit) async {
    emit(const LoginLoadingState());
    final Either<Failure, SavedUser> result = await loginUseCase(event.options);

    result.fold((failure) {
      if (failure is AuthFailure) {
        emit(LoginErrorState(failure.message, ErrorType.auth));
      }
      if (failure is NetworkFailure) {
        emit(LoginErrorState(failure.message, ErrorType.network));
      }
      if (failure is ServerFailure) {
        emit(LoginErrorState(failure.message, ErrorType.normal));
      }
    }, (user) {
      emit(LoginSuccessState(user));
    });
  }

  FutureOr<void> _googleSign(
      GoogleSignInEvent event, Emitter<LoginState> emit) async {
    emit(const GoogleLoginLoadingState());
    final Either<Failure, SavedUser> result = await googleSignUseCase();

    result.fold((failure) {
      if (failure is AuthFailure) {
        emit(LoginErrorState(failure.message, ErrorType.auth));
      }
      if (failure is NetworkFailure) {
        emit(LoginErrorState(failure.message, ErrorType.network));
      }
      if (failure is ServerFailure) {
        emit(LoginErrorState(failure.message, ErrorType.normal));
      }
    }, (user) {
      emit(LoginSuccessState(user));
    });
  }
}

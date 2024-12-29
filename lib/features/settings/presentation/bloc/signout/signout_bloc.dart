import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/features/auth/domain/usecases/user/signout_usecase.dart';

part 'signout_events.dart';
part 'signout_states.dart';

class SignOutBloc extends Bloc<SignOutEvent, SignOutState> {
  final SignOutUseCase signOutUseCase;

  SignOutBloc(this.signOutUseCase) : super(const SignOutInitialState()) {
    on<SignOutEventStarted>(_signOut);
  }

  FutureOr<void> _signOut(
      SignOutEventStarted event, Emitter<SignOutState> emit) async {
    emit(const SignOutLoadingState());
    final Either<Failure, Unit> result = await signOutUseCase();
    result.fold((failure) {
      if (failure is NetworkFailure) {
        emit(
          SignOutErrorState(
            failure.message,
            errorType: ErrorType.network,
          ),
        );
      } else {
        emit(
          SignOutErrorState(failure.message, errorType: ErrorType.normal),
        );
      }
    }, (_) {
      emit(const SignOutSuccessState());
    });
  }
}

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/features/auth/domain/entities/saved_user.dart';
import 'package:your_chef/features/auth/domain/usecases/auth/google_sign_in_usecase.dart';

import '../../../../../core/errors/failures.dart';

part 'google_sign_in_events.dart';
part 'google_sign_in_states.dart';

class GoogleSignInBloc extends Bloc<GoogleSignInEvent, GoogleSignInState> {
  final GoogleSignUseCase googleSignUseCase;
  GoogleSignInBloc(this.googleSignUseCase)
      : super(const GoogleSignInInitialState()) {
    on<GoogleSignInEventStarted>(_googleSign);
  }

  FutureOr<void> _googleSign(
      GoogleSignInEventStarted event, Emitter<GoogleSignInState> emit) async {
    emit(const GoogleSignInLoadingState());
    final Either<Failure, SavedUser> result = await googleSignUseCase();

    result.fold((failure) {
      if (failure is AuthFailure) {
        emit(GoogleSignInErrorState(failure.message, ErrorType.auth));
      }
      if (failure is NetworkFailure) {
        emit(GoogleSignInErrorState(failure.message, ErrorType.network));
      }
      if (failure is ServerFailure) {
        emit(GoogleSignInErrorState(failure.message, ErrorType.normal));
      }
    }, (user) {
      emit(GoogleSignInSuccessState(user));
    });
  }
}

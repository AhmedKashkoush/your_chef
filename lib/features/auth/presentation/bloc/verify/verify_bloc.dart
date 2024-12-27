import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/auth/domain/usecases/auth/send_otp_usecase.dart';
import 'package:your_chef/features/auth/domain/usecases/auth/verify_otp_usecase.dart';

part 'verify_events.dart';
part 'verify_states.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  VerifyBloc(this.sendOtpUseCase, this.verifyOtpUseCase)
      : super(const VerifyInitialState()) {
    on<SendOtpEvent>(_sendCode);
    on<VerifyOtpEvent>(_verifyCode);
  }

  FutureOr<void> _sendCode(
      SendOtpEvent event, Emitter<VerifyState> emit) async {
    emit(const VerifyLoadingState());
    final Either<Failure, Unit> result = await sendOtpUseCase(event.options);
    result.fold((failure) {
      if (failure is AuthFailure) {
        emit(VerifyErrorState(failure.message, ErrorType.auth));
      }
      if (failure is NetworkFailure) {
        emit(VerifyErrorState(failure.message, ErrorType.network));
      }
      if (failure is ServerFailure) {
        emit(VerifyErrorState(failure.message, ErrorType.normal));
      }
    }, (_) {
      emit(const CodeSentSuccessState());
    });
  }

  FutureOr<void> _verifyCode(
      VerifyOtpEvent event, Emitter<VerifyState> emit) async {
    emit(const VerifyLoadingState());
    final Either<Failure, Unit> result = await verifyOtpUseCase(event.options);
    result.fold((failure) {
      if (failure is AuthFailure) {
        emit(VerifyErrorState(failure.message, ErrorType.auth));
      }
      if (failure is NetworkFailure) {
        emit(VerifyErrorState(failure.message, ErrorType.network));
      }
      if (failure is ServerFailure) {
        emit(VerifyErrorState(failure.message, ErrorType.normal));
      }
    }, (_) {
      emit(const VerifySuccessState());
    });
  }
}

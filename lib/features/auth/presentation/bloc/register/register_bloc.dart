import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/auth/domain/usecases/auth/register_usecase.dart';

part 'register_events.dart';
part 'register_states.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;
  RegisterBloc(this.registerUseCase) : super(const RegisterInitialState()) {
    on<RegisterSubmitEvent>(_register);
  }

  FutureOr<void> _register(
      RegisterSubmitEvent event, Emitter<RegisterState> emit) async {
    emit(const RegisterLoadingState());
    final Either<Failure, String> result = await registerUseCase(event.options);

    result.fold((failure) {
      if (failure is AuthFailure) {
        emit(RegisterErrorState(failure.message, ErrorType.auth));
      }
      if (failure is NetworkFailure) {
        emit(RegisterErrorState(failure.message, ErrorType.network));
      }
      if (failure is ServerFailure) {
        emit(RegisterErrorState(failure.message, ErrorType.normal));
      }
    }, (uid) {
      emit(RegisterSuccessState(uid));
    });
  }
}

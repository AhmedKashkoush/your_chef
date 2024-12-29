import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/features/auth/domain/entities/saved_user.dart';
import 'package:your_chef/features/auth/domain/entities/user.dart';
import 'package:your_chef/features/auth/domain/usecases/user/switch_user_usecase.dart';

part 'switch_account_events.dart';
part 'switch_account_states.dart';

class SwitchAccountBloc extends Bloc<SwitchAccountEvent, SwitchAccountState> {
  final SwitchUserUseCase switchUserUseCase;

  SwitchAccountBloc(this.switchUserUseCase)
      : super(const SwitchAccountInitialState()) {
    on<SwitchAccountEventStarted>(_switchAccount);
  }

  FutureOr<void> _switchAccount(
      SwitchAccountEventStarted event, Emitter<SwitchAccountState> emit) async {
    emit(const SwitchAccountLoadingState());
    final Either<Failure, User> result =
        await switchUserUseCase(event.savedUser);
    result.fold((failure) {
      if (failure is NetworkFailure) {
        emit(
          SwitchAccountErrorState(
            failure.message,
            errorType: ErrorType.network,
          ),
        );
      }
      if (failure is AuthFailure) {
        emit(
          SwitchAccountErrorState(
            failure.message,
            errorType: ErrorType.auth,
          ),
        );
      }
      if (failure is ServerFailure) {
        emit(
          SwitchAccountErrorState(
            failure.message,
            errorType: ErrorType.normal,
          ),
        );
      }
    }, (user) {
      emit(SwitchAccountSuccessState(user));
    });
  }
}

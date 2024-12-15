import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/utils/user_helper.dart';
import 'package:your_chef/features/settings/domain/usecases/sign_out_usecase.dart';
import 'package:your_chef/features/settings/domain/usecases/switch_account_usecase.dart';

part 'settings_events.dart';
part 'settings_states.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SignOutUseCase signOutUseCase;
  final SwitchAccountUseCase switchAccountUseCase;
  SettingsBloc(this.signOutUseCase, this.switchAccountUseCase)
      : super(const SettingsInitialState()) {
    on<SignOutEvent>(_signOut);
    on<SwitchAccountEvent>(_switchAccount);
  }

  FutureOr<void> _signOut(
      SignOutEvent event, Emitter<SettingsState> emit) async {
    emit(const SettingsLoadingState());
    final Either<Failure, Unit> result = await signOutUseCase();
    result.fold((failure) {
      if (failure is NetworkFailure) {
        emit(
          SettingsErrorState(
            failure.message,
            ErrorType.network,
          ),
        );
      } else {
        emit(
          SettingsErrorState(
            failure.message,
          ),
        );
      }
    }, (_) {
      emit(const SettingsSuccessState());
    });
  }

  FutureOr<void> _switchAccount(
      SwitchAccountEvent event, Emitter<SettingsState> emit) async {
    emit(const SettingsLoadingState());
    final Either<Failure, Unit> result =
        await switchAccountUseCase(event.savedUser);
    result.fold((failure) {
      if (failure is NetworkFailure) {
        emit(
          SettingsErrorState(
            failure.message,
            ErrorType.network,
          ),
        );
      }
      if (failure is AuthFailure) {
        emit(
          SettingsErrorState(
            failure.message,
            ErrorType.auth,
          ),
        );
      }
      if (failure is ServerFailure) {
        emit(
          SettingsErrorState(
            failure.message,
            ErrorType.normal,
          ),
        );
      }
    }, (_) {
      emit(const SettingsSuccessState());
    });
  }
}

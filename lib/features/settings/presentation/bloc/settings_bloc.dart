import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/features/settings/domain/usecases/sign_out_usecase.dart';

part 'settings_events.dart';
part 'settings_states.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SignOutUseCase signOutUseCase;
  SettingsBloc(this.signOutUseCase) : super(const SettingsInitialState()) {
    on<SignOutEvent>(_signOut);
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
}

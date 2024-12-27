import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/auth/domain/usecases/auth/upload_profile_photo_usecase.dart';

part 'upload_profile_photo_events.dart';
part 'upload_profile_photo_states.dart';

class UploadProfilePhotoBloc
    extends Bloc<UploadProfilePhotoEvent, UploadProfilePhotoState> {
  final UploadProfilePhotoUseCase uploadProfilePhotoUseCase;
  UploadProfilePhotoBloc(this.uploadProfilePhotoUseCase)
      : super(
          const UploadProfilePhotoInitialState(),
        ) {
    on<UploadProfilePhotoSubmitEvent>(_submitPhoto);
  }

  FutureOr<void> _submitPhoto(UploadProfilePhotoSubmitEvent event,
      Emitter<UploadProfilePhotoState> emit) async {
    emit(const UploadProfilePhotoLoadingState());
    final Either<Failure, Unit> result =
        await uploadProfilePhotoUseCase(event.options);

    result.fold((failure) {
      if (failure is AuthFailure) {
        emit(UploadProfilePhotoErrorState(failure.message, ErrorType.auth));
      }
      if (failure is NetworkFailure) {
        emit(UploadProfilePhotoErrorState(failure.message, ErrorType.network));
      }
      if (failure is ServerFailure) {
        emit(UploadProfilePhotoErrorState(failure.message, ErrorType.normal));
      }
    }, (_) {
      emit(const UploadProfilePhotoSuccessState());
    });
  }
}

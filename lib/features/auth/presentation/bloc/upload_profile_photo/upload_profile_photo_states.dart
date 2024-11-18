part of 'upload_profile_photo_bloc.dart';

abstract class UploadProfilePhotoState extends Equatable {
  const UploadProfilePhotoState();
}

class UploadProfilePhotoInitialState extends UploadProfilePhotoState {
  const UploadProfilePhotoInitialState();
  @override
  List<Object> get props => [];
}

class UploadProfilePhotoLoadingState extends UploadProfilePhotoState {
  const UploadProfilePhotoLoadingState();
  @override
  List<Object> get props => [];
}

class UploadProfilePhotoSuccessState extends UploadProfilePhotoState {
  const UploadProfilePhotoSuccessState();
  @override
  List<Object> get props => [];
}

class UploadProfilePhotoErrorState extends UploadProfilePhotoState {
  final String message;
  final ErrorType type;

  const UploadProfilePhotoErrorState(this.message, this.type);
  @override
  List<Object> get props => [message, type];
}

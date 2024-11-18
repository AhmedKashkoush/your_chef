part of 'upload_profile_photo_bloc.dart';

abstract class UploadProfilePhotoEvent extends Equatable {
  const UploadProfilePhotoEvent();
}

class UploadProfilePhotoSubmitEvent extends UploadProfilePhotoEvent {
  final UploadProfileOptions options;
  const UploadProfilePhotoSubmitEvent(this.options);
  @override
  List<Object> get props => [options];
}

part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();
}

class GetUserEvent extends UserEvent {
  const GetUserEvent();
  @override
  List<Object?> get props => [];
}

class GetSavedUsersEvent extends UserEvent {
  const GetSavedUsersEvent();
  @override
  List<Object?> get props => [];
}

class SaveUserEvent extends UserEvent {
  final SavedUser savedUser;
  const SaveUserEvent(this.savedUser);
  @override
  List<Object?> get props => [savedUser];
}

class SwitchUserEvent extends UserEvent {
  final SavedUser savedUser;
  const SwitchUserEvent(this.savedUser);
  @override
  List<Object?> get props => [savedUser];
}

class DeleteUserEvent extends UserEvent {
  final SavedUser savedUser;
  const DeleteUserEvent(this.savedUser);
  @override
  List<Object?> get props => [savedUser];
}

class DeleteSavedUserEvent extends UserEvent {
  final SavedUser savedUser;
  const DeleteSavedUserEvent(this.savedUser);
  @override
  List<Object?> get props => [savedUser];
}

class UpdateUserEvent extends UserEvent {
  final UserOptions options;
  const UpdateUserEvent(this.options);
  @override
  List<Object?> get props => [options];
}

class SetUserEvent extends UserEvent {
  final User user;
  const SetUserEvent(this.user);
  @override
  List<Object?> get props => [user];
}

class LogoutEvent extends UserEvent {
  const LogoutEvent();
  @override
  List<Object?> get props => [];
}

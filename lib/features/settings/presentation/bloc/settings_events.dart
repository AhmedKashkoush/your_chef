part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class SignOutEvent extends SettingsEvent {
  const SignOutEvent();

  @override
  List<Object?> get props => [];
}

class SwitchAccountEvent extends SettingsEvent {
  final SavedUser savedUser;
  const SwitchAccountEvent(this.savedUser);

  @override
  List<Object?> get props => [savedUser];
}

part of 'switch_account_bloc.dart';

sealed class SwitchAccountEvent extends Equatable {
  const SwitchAccountEvent();

  @override
  List<Object> get props => [];
}

class SwitchAccountEventStarted extends SwitchAccountEvent {
  final SavedUser savedUser;

  const SwitchAccountEventStarted(this.savedUser);

  @override
  List<Object> get props => [savedUser];
}

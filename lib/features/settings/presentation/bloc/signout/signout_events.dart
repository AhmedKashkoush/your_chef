part of 'signout_bloc.dart';

sealed class SignOutEvent extends Equatable {
  const SignOutEvent();
  @override
  List<Object> get props => [];
}

class SignOutEventStarted extends SignOutEvent {
  const SignOutEventStarted();
}

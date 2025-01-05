part of 'google_sign_in_bloc.dart';

abstract class GoogleSignInEvent extends Equatable {
  const GoogleSignInEvent();
}

class GoogleSignInEventStarted extends GoogleSignInEvent {
  const GoogleSignInEventStarted();
  @override
  List<Object> get props => [];
}

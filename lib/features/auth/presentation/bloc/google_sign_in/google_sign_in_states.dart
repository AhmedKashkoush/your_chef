part of 'google_sign_in_bloc.dart';

sealed class GoogleSignInState extends Equatable {
  const GoogleSignInState();
}

class GoogleSignInInitialState extends GoogleSignInState {
  const GoogleSignInInitialState();
  @override
  List<Object> get props => [];
}

class GoogleSignInLoadingState extends GoogleSignInState {
  const GoogleSignInLoadingState();
  @override
  List<Object> get props => [];
}

class GoogleSignInSuccessState extends GoogleSignInState {
  final SavedUser user;

  const GoogleSignInSuccessState(this.user);
  @override
  List<Object> get props => [user];
}

class GoogleSignInErrorState extends GoogleSignInState {
  final String message;
  final ErrorType type;

  const GoogleSignInErrorState(this.message, [this.type = ErrorType.normal]);
  @override
  List<Object> get props => [message, type];
}

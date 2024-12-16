part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitialState extends LoginState {
  const LoginInitialState();
  @override
  List<Object> get props => [];
}

class LoginLoadingState extends LoginState {
  const LoginLoadingState();
  @override
  List<Object> get props => [];
}

class GoogleLoginLoadingState extends LoginState {
  const GoogleLoginLoadingState();
  @override
  List<Object> get props => [];
}

class LoginSuccessState extends LoginState {
  final SavedUser user;

  const LoginSuccessState(this.user);
  @override
  List<Object> get props => [user];
}

class LoginErrorState extends LoginState {
  final String message;
  final ErrorType type;

  const LoginErrorState(this.message, [this.type = ErrorType.normal]);
  @override
  List<Object> get props => [message, type];
}

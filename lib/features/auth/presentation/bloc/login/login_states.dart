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

class LoginSuccessState extends LoginState {
  final User user;

  const LoginSuccessState(this.user);
  @override
  List<Object> get props => [user];
}

class LoginErrorState extends LoginState {
  final String message;

  const LoginErrorState(this.message);
  @override
  List<Object> get props => [message];
}

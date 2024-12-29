part of 'signout_bloc.dart';

sealed class SignOutState extends Equatable {
  const SignOutState();

  @override
  List<Object> get props => [];
}

class SignOutInitialState extends SignOutState {
  const SignOutInitialState();
}

class SignOutLoadingState extends SignOutState {
  const SignOutLoadingState();
}

class SignOutSuccessState extends SignOutState {
  const SignOutSuccessState();
}

class SignOutErrorState extends SignOutState {
  final String error;
  final ErrorType errorType;
  const SignOutErrorState(this.error, {this.errorType = ErrorType.normal});

  @override
  List<Object> get props => [error, errorType];
}

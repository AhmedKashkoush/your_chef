part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
}

class RegisterInitialState extends RegisterState {
  const RegisterInitialState();
  @override
  List<Object> get props => [];
}

class RegisterLoadingState extends RegisterState {
  const RegisterLoadingState();
  @override
  List<Object> get props => [];
}

class RegisterSuccessState extends RegisterState {
  const RegisterSuccessState();
  @override
  List<Object> get props => [];
}

class RegisterErrorState extends RegisterState {
  final String message;

  const RegisterErrorState(this.message);
  @override
  List<Object> get props => [message];
}

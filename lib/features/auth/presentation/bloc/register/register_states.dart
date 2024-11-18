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
  final String uid;
  const RegisterSuccessState(this.uid);
  @override
  List<Object> get props => [uid];
}

class RegisterErrorState extends RegisterState {
  final String message;
  final ErrorType type;

  const RegisterErrorState(this.message, this.type);
  @override
  List<Object> get props => [message, type];
}

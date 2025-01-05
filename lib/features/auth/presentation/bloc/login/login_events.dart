part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginSubmitEvent extends LoginEvent {
  final LoginOptions options;
  const LoginSubmitEvent(this.options);
  @override
  List<Object> get props => [options];
}

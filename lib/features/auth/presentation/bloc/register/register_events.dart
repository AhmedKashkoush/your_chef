part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class RegisterSubmitEvent extends RegisterEvent {
  final RegisterOptions options;
  const RegisterSubmitEvent(this.options);
  @override
  List<Object> get props => [options];
}

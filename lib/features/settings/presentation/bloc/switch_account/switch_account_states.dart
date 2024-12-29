part of 'switch_account_bloc.dart';

sealed class SwitchAccountState extends Equatable {
  const SwitchAccountState();

  @override
  List<Object?> get props => [];
}

class SwitchAccountInitialState extends SwitchAccountState {
  const SwitchAccountInitialState();
}

class SwitchAccountLoadingState extends SwitchAccountState {
  const SwitchAccountLoadingState();
}

class SwitchAccountSuccessState extends SwitchAccountState {
  final User user;
  const SwitchAccountSuccessState(this.user);

  @override
  List<Object?> get props => [user];
}

class SwitchAccountErrorState extends SwitchAccountState {
  final String error;
  final ErrorType errorType;
  const SwitchAccountErrorState(this.error,
      {this.errorType = ErrorType.normal});

  @override
  List<Object?> get props => [error, errorType];
}

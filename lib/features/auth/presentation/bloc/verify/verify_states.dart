part of 'verify_bloc.dart';

abstract class VerifyState extends Equatable {
  const VerifyState();
}

class VerifyInitialState extends VerifyState {
  const VerifyInitialState();

  @override
  List<Object?> get props => [];
}

class VerifyLoadingState extends VerifyState {
  const VerifyLoadingState();

  @override
  List<Object?> get props => [];
}

class VerifySuccessState extends VerifyState {
  const VerifySuccessState();

  @override
  List<Object?> get props => [];
}

class CodeSentSuccessState extends VerifyState {
  const CodeSentSuccessState();

  @override
  List<Object?> get props => [];
}

class VerifyErrorState extends VerifyState {
  final String error;
  final ErrorType type;
  const VerifyErrorState(this.error, [this.type = ErrorType.normal]);

  @override
  List<Object?> get props => [error, type];
}

part of 'verify_bloc.dart';

abstract class VerifyEvent extends Equatable {
  const VerifyEvent();
}

class SendOtpEvent extends VerifyEvent {
  final ResetPasswordOptions options;
  const SendOtpEvent(this.options);

  @override
  List<Object?> get props => [options];
}

class VerifyOtpEvent extends VerifyEvent {
  final VerifyOtpOptions options;
  const VerifyOtpEvent(this.options);

  @override
  List<Object?> get props => [options];
}

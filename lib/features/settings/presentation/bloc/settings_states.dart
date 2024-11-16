part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsInitialState extends SettingsState {
  const SettingsInitialState();
  @override
  List<Object> get props => [];
}

class SettingsLoadingState extends SettingsState {
  const SettingsLoadingState();
  @override
  List<Object> get props => [];
}

class SettingsSuccessState extends SettingsState {
  const SettingsSuccessState();
  @override
  List<Object> get props => [];
}

class SettingsErrorState extends SettingsState {
  final String message;
  final ErrorType type;

  const SettingsErrorState(this.message, [this.type = ErrorType.normal]);
  @override
  List<Object> get props => [message];
}

part of 'user_bloc.dart';

class UserState extends Equatable {
  final User? user;
  final List<SavedUser> savedUsers;
  final bool switchUser;
  final RequestStatus status;
  final ErrorType errorType;
  final String error;

  const UserState({
    this.user,
    this.savedUsers = const [],
    this.switchUser = false,
    this.status = RequestStatus.initial,
    this.errorType = ErrorType.normal,
    this.error = '',
  });

  UserState copyWith({
    User? user,
    List<SavedUser>? savedUsers,
    bool? switchUser,
    RequestStatus? status,
    ErrorType? errorType,
    String? error,
  }) {
    return UserState(
      user: user ?? this.user,
      savedUsers: savedUsers ?? this.savedUsers,
      switchUser: switchUser ?? this.switchUser,
      status: status ?? this.status,
      errorType: errorType ?? this.errorType,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props =>
      [user, savedUsers, switchUser, status, errorType, error];
}

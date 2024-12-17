import 'package:equatable/equatable.dart';
import 'package:your_chef/features/user/domain/entities/user.dart';

class SavedUser extends Equatable {
  final User user;
  final String? provider, idToken, accessToken, password;
  final DateTime lastLogin;
  const SavedUser({
    required this.user,
    this.provider,
    this.idToken,
    this.accessToken,
    this.password,
    required this.lastLogin,
  });

  @override
  List<Object?> get props =>
      [user, provider, idToken, accessToken, password, lastLogin];
}

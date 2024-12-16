import 'package:equatable/equatable.dart';
import 'package:your_chef/features/user/domain/entities/user.dart';

class SavedUser extends Equatable {
  final User user;
  final String? provider;
  final String? idToken;
  final String? accessToken;
  final String? password;
  const SavedUser({
    required this.user,
    this.provider,
    this.idToken,
    this.accessToken,
    this.password,
  });

  @override
  List<Object?> get props => [user, provider, idToken, accessToken, password];
}

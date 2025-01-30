import 'package:equatable/equatable.dart';

import 'package:your_chef/features/auth/data/models/user_model.dart';
import 'package:your_chef/features/auth/domain/entities/saved_user.dart';

class SavedUserModel extends Equatable {
  final UserModel user;
  final String? provider, idToken, accessToken, password;
  final DateTime lastLogin;
  const SavedUserModel({
    required this.user,
    this.provider,
    this.idToken,
    this.accessToken,
    this.password,
    required this.lastLogin,
  });

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'provider': provider,
        'idToken': idToken,
        'accessToken': accessToken,
        'password': password,
        'lastLogin': lastLogin.toIso8601String(),
      };

  factory SavedUserModel.fromJson(Map<String, dynamic> json) {
    return SavedUserModel(
      user: UserModel.fromJson(json['user']),
      provider: json['provider'],
      idToken: json['idToken'],
      accessToken: json['accessToken'],
      password: json['password'],
      lastLogin: DateTime.parse(json['lastLogin'] ?? ''),
    );
  }
  factory SavedUserModel.fromEntity(SavedUser savedUser) => SavedUserModel(
        user: UserModel.fromEntity(savedUser.user),
        provider: savedUser.provider,
        idToken: savedUser.idToken,
        accessToken: savedUser.accessToken,
        password: savedUser.password,
        lastLogin: savedUser.lastLogin,
      );

  SavedUser toEntity() => SavedUser(
        user: user.toEntity(),
        provider: provider,
        idToken: idToken,
        accessToken: accessToken,
        password: password,
        lastLogin: lastLogin,
      );

  @override
  List<Object?> get props =>
      [user, provider, idToken, accessToken, password, lastLogin];
}

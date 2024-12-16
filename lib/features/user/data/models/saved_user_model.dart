import 'package:equatable/equatable.dart';

import 'package:your_chef/features/user/data/models/user_model.dart';
import 'package:your_chef/features/user/domain/entities/saved_user.dart';

class SavedUserModel extends Equatable {
  final UserModel user;
  final String? provider;
  final String? idToken;
  final String? accessToken;
  final String? password;
  const SavedUserModel({
    required this.user,
    this.provider,
    this.idToken,
    this.accessToken,
    this.password,
  });

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'provider': provider,
        'idToken': idToken,
        'accessToken': accessToken,
        'password': password,
      };

  factory SavedUserModel.fromJson(Map<String, dynamic> json) => SavedUserModel(
        user: UserModel.fromJson(json['user']),
        provider: json['provider'],
        idToken: json['idToken'],
        accessToken: json['accessToken'],
        password: json['password'],
      );
  factory SavedUserModel.fromEntity(SavedUser savedUser) => SavedUserModel(
        user: UserModel.fromEntity(savedUser.user),
        provider: savedUser.provider,
        idToken: savedUser.idToken,
        accessToken: savedUser.accessToken,
        password: savedUser.password,
      );

  SavedUser toEntity() => SavedUser(
        user: user.toEntity(),
        provider: provider,
        idToken: idToken,
        accessToken: accessToken,
        password: password,
      );

  @override
  List<Object?> get props => [user, provider, idToken, accessToken, password];
}

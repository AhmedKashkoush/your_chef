import 'dart:convert';
import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:your_chef/core/constants/keys.dart';
import 'package:your_chef/core/utils/secure_storage_helper.dart';
import 'package:your_chef/features/auth/data/models/user_model.dart';
import 'package:your_chef/locator.dart';

import '../../features/auth/domain/entities/user.dart';

class UserHelper {
  static User? _user;
  const UserHelper._();
  static User? get user => _user;
  static Future<void> checkUser() async {
    if (_user != null) return;
    final supabase.User? currentUser =
        locator<supabase.SupabaseClient>().auth.currentUser;
    if (currentUser == null) return;
    final String? data = await SecureStorageHelper.read(SharedPrefsKeys.user);
    if (data == null) return;
    UserModel user = UserModel.fromJson(jsonDecode(data));
    _user = user.toEntity();
  }

  static Future<void> signIn(UserModel user) async {
    await SecureStorageHelper.write(
        SharedPrefsKeys.user, jsonEncode(user.toJson()));
    _user = user.toEntity();
  }

  static Future<void> signOut() async {
    await SecureStorageHelper.delete(SharedPrefsKeys.user);
    _user = null;
  }

  static Future<List<SavedUser>> getSavedUsers() async {
    final String? data =
        await SecureStorageHelper.read(SharedPrefsKeys.savedUsers);
    final List savedUsers = data == null ? [] : jsonDecode(data);
    log(savedUsers.toString());
    return savedUsers.map((user) => SavedUser.fromJson(user)).toList();
  }

  static Future<void> saveUser(
      {String? password,
      String? provider,
      String? idToken,
      String? accessToken}) async {
    if (_user == null) return;
    final String? data =
        await SecureStorageHelper.read(SharedPrefsKeys.savedUsers);
    final List savedUsers = data == null ? [] : jsonDecode(data);
    if (savedUsers.any((user) => user['user']['id'] == _user!.id)) return;
    savedUsers.add({
      'user': UserModel.fromEntity(_user!).toJson(),
      'provider': provider,
      'idToken': idToken,
      'accessToken': accessToken,
      'password': password,
    });
    await SecureStorageHelper.write(
        SharedPrefsKeys.savedUsers, jsonEncode(savedUsers));
  }
}

class SavedUser {
  final User user;
  final String? provider;
  final String? idToken;
  final String? accessToken;
  final String? password;
  SavedUser({
    required this.user,
    this.provider,
    this.idToken,
    this.accessToken,
    this.password,
  });

  Map<String, dynamic> toJson() => {
        'user': UserModel.fromEntity(user).toJson(),
        'provider': provider,
        'idToken': idToken,
        'accessToken': accessToken,
        'password': password,
      };

  static SavedUser fromJson(Map<String, dynamic> json) => SavedUser(
        user: UserModel.fromJson(json['user']).toEntity(),
        provider: json['provider'],
        idToken: json['idToken'],
        accessToken: json['accessToken'],
        password: json['password'],
      );
}

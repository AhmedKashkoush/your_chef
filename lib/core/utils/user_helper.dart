import 'dart:convert';

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
}

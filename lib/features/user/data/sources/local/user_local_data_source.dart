import 'dart:convert';

import 'package:your_chef/core/constants/keys.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/errors/exceptions.dart';
import 'package:your_chef/core/utils/secure_storage_helper.dart';
import 'package:your_chef/features/user/data/models/saved_user_model.dart';
import 'package:your_chef/features/user/data/models/user_model.dart';

abstract class IUserLocalDataSource {
  const IUserLocalDataSource();
  Future<UserModel> getUser();
  Future<List<SavedUserModel>> getSavedUsers();

  Future<void> deleteSavedUser(SavedUserModel savedUser);
  Future<void> saveUser(SavedUserModel savedUser);
}

class SecureStorageUserLocalDataSource extends IUserLocalDataSource {
  const SecureStorageUserLocalDataSource();

  @override
  Future<void> deleteSavedUser(SavedUserModel savedUser) async {
    final String? data =
        await SecureStorageHelper.read(SharedPrefsKeys.savedUsers);

    if (data == null) return;

    final List<SavedUserModel> savedUsers =
        List<Map<String, dynamic>>.from(jsonDecode(data) as List)
            .map((user) => SavedUserModel.fromJson(user))
            .toList();

    savedUsers.removeWhere((user) => user.user.id == savedUser.user.id);

    await SecureStorageHelper.write(
      SharedPrefsKeys.savedUsers,
      jsonEncode(savedUsers.map((user) => user.toJson()).toList()),
    );
  }

  @override
  Future<UserModel> getUser() async {
    final String? data = await SecureStorageHelper.read(SharedPrefsKeys.user);
    if (data == null) throw const AuthException(AppStrings.sessionExpired);
    return UserModel.fromJson(jsonDecode(data));
  }

  @override
  Future<void> saveUser(SavedUserModel savedUser) async {
    final String? data =
        await SecureStorageHelper.read(SharedPrefsKeys.savedUsers);
    final List<SavedUserModel> savedUsers = data == null
        ? []
        : List<Map<String, dynamic>>.from(jsonDecode(data))
            .map((user) => SavedUserModel.fromJson(user))
            .toList();
    savedUsers.removeWhere((user) => user.user.id == savedUser.user.id);
    savedUsers.add(savedUser);

    await SecureStorageHelper.write(SharedPrefsKeys.savedUsers,
        jsonEncode(savedUsers.map((user) => user.toJson()).toList()));
  }

  @override
  Future<List<SavedUserModel>> getSavedUsers() async {
    // await SecureStorageHelper.delete(SharedPrefsKeys.savedUsers);
    final String? data =
        await SecureStorageHelper.read(SharedPrefsKeys.savedUsers);
    final List<Map<String, dynamic>> savedUsers =
        data == null ? [] : List<Map<String, dynamic>>.from(jsonDecode(data));

    final List<SavedUserModel> sortedSavedUsers = savedUsers.map((user) {
      return SavedUserModel.fromJson(user);
    }).toList()
      ..sort((user1, user2) => user1.lastLogin.compareTo(user2.lastLogin));
    return sortedSavedUsers;
  }
}

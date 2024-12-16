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

  Future<void> deleteSavedUser(SavedUserModel user);
}

class SecureStorageUserLocalDataSource extends IUserLocalDataSource {
  const SecureStorageUserLocalDataSource();

  @override
  Future<void> deleteSavedUser(SavedUserModel user) async {
    final String? data =
        await SecureStorageHelper.read(SharedPrefsKeys.savedUsers);

    if (data == null) return;

    final List<SavedUserModel> savedUsers = (jsonDecode(data) as List)
        .map((e) => SavedUserModel.fromJson(e))
        .toList();

    savedUsers.removeWhere((savedUser) => savedUser.user.id == user.user.id);

    await SecureStorageHelper.write(
      SharedPrefsKeys.savedUsers,
      jsonEncode(savedUsers),
    );
  }

  @override
  Future<UserModel> getUser() async {
    final String? data = await SecureStorageHelper.read(SharedPrefsKeys.user);
    if (data == null) throw AuthException(AppStrings.sessionExpired);
    return UserModel.fromJson(jsonDecode(data));
  }
}

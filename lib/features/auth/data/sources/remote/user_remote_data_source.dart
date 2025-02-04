import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/core/constants/keys.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/errors/exceptions.dart' as ex;
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/core/utils/secure_storage_helper.dart';
import 'package:your_chef/features/auth/data/models/saved_user_model.dart';
import 'package:your_chef/features/auth/data/models/user_model.dart';

abstract class IUserRemoteDataSource {
  const IUserRemoteDataSource();
  Future<UserModel> getUser();
  Future<void> updateUser(UserOptions options);
  Future<void> deleteUser();
  Future<UserModel> switchUser(SavedUserModel savedUser);
  Future<void> signOut();
}

class SupabaseUserRemoteDataSource extends IUserRemoteDataSource {
  final SupabaseClient client;
  const SupabaseUserRemoteDataSource(this.client);

  @override
  Future<void> deleteUser() async {
    final bool isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    // await client.auth.signOut();
  }

  @override
  Future<UserModel> getUser() async {
    final bool isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    final User? user = client.auth.currentUser;
    if (user == null) {
      await client.auth.signOut();
      await SecureStorageHelper.delete(
        SharedPrefsKeys.user,
      );
      throw ex.AuthException(AppStrings.sessionExpired.tr());
    }
    final Map<String, dynamic> data =
        await client.from('users').select('*').eq('id', user.id).single();
    return UserModel.fromJson(data);
  }

  @override
  Future<UserModel> switchUser(SavedUserModel savedUser) async {
    final bool isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
    }

    late final AuthResponse response;
    if (savedUser.password != null) {
      response = await client.auth
          .signInWithPassword(
        email: savedUser.user.email,
        password: savedUser.password!,
      )
          .catchError((error) async {
        await client.auth.signOut();
        await SecureStorageHelper.delete(
          SharedPrefsKeys.user,
        );
        throw ex.AuthException(AppStrings.sessionExpired.tr());
      });
    }

    if (savedUser.provider != null) {
      response = await client.auth
          .signInWithIdToken(
        provider: OAuthProvider.values.byName(savedUser.provider!),
        idToken: savedUser.idToken!,
        accessToken: savedUser.accessToken,
      )
          .catchError((error) async {
        await client.auth.signOut();
        await SecureStorageHelper.delete(
          SharedPrefsKeys.user,
        );
        throw ex.AuthException(AppStrings.sessionExpired.tr());
      });
    }
    final User? user = response.session?.user;
    if (user == null) {
      await client.auth.signOut();
      await SecureStorageHelper.delete(
        SharedPrefsKeys.user,
      );
      throw ex.AuthException(AppStrings.sessionExpired.tr());
    }
    final Map<String, dynamic> data =
        await client.from('users').select('*').eq('id', user.id).single();

    if (data.isEmpty) {
      await client.auth.signOut();
      await SecureStorageHelper.delete(
        SharedPrefsKeys.user,
      );
      throw ex.AuthException(AppStrings.invalidCredentials.tr());
    }
    final UserModel signedUser = UserModel.fromJson(data);

    final String? savedUsersData =
        await SecureStorageHelper.read(SharedPrefsKeys.savedUsers);

    if (savedUsersData != null) {
      final List<SavedUserModel> savedUsers =
          List<Map<String, dynamic>>.from(jsonDecode(savedUsersData) as List)
              .map((user) => SavedUserModel.fromJson(user))
              .toList();
      savedUsers.removeWhere((user) => user.user.id == savedUser.user.id);
      savedUsers.add(
        SavedUserModel.fromJson(
          {
            'user': signedUser.toJson(),
            'provider': savedUser.provider,
            'idToken': savedUser.idToken,
            'accessToken': savedUser.accessToken,
            'password': savedUser.password,
            'lastLogin': DateTime.now().toIso8601String(),
          },
        ),
      );

      await SecureStorageHelper.write(
        SharedPrefsKeys.savedUsers,
        jsonEncode(savedUsers.map((user) => user.toJson()).toList()),
      );
    }
    await SecureStorageHelper.write(
      SharedPrefsKeys.user,
      jsonEncode(signedUser.toJson()),
    );
    return signedUser;
  }

  @override
  Future<void> updateUser(UserOptions options) async {
    final bool isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    if (options.photo == null) {
      await client
          .from('users')
          .update(UserModel.fromEntity(options.user).toJson())
          .eq('id', options.user.id);
      return;
    }
    final String filename =
        '${options.user.id}/${DateTime.now().millisecondsSinceEpoch}';
    await client.storage.from('avatars').upload(filename, options.photo!);
    final String url = client.storage.from('avatars').getPublicUrl(filename);

    final data = {
      'name': options.user.name,
      'email': options.user.email,
      'address': options.user.address,
      'phone': options.user.phone,
      'image': url,
    };
    await client.from('users').update(data).eq('id', options.user.id);
  }

  @override
  Future<void> signOut() async {
    await client.auth.signOut();
    await SecureStorageHelper.delete(
      SharedPrefsKeys.user,
    );
  }
}

import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/errors/exceptions.dart' as ex;
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/core/utils/user_helper.dart';
import 'package:your_chef/features/auth/data/models/user_model.dart';

abstract class ISettingsRemoteDataSource {
  const ISettingsRemoteDataSource();

  Future<void> signOut();
  Future<void> switchAccount(SavedUser savedUser);
}

class SupabaseSettingsRemoteDataSource extends ISettingsRemoteDataSource {
  final SupabaseClient client;

  const SupabaseSettingsRemoteDataSource(this.client);
  @override
  Future<void> signOut() async {
    final bool isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection);
    }
    await client.auth.signOut().catchError(
          (error) => throw ex.ServerException(AppStrings.somethingWentWrong),
        );
    await UserHelper.signOut();
  }

  @override
  Future<void> switchAccount(SavedUser savedUser) async {
    final bool isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection);
    }
    // await client.auth.signOut().catchError(
    //       (error) => throw ex.ServerException(AppStrings.somethingWentWrong),
    //     );

    late final AuthResponse response;
    if (savedUser.password != null) {
      response = await client.auth
          .signInWithPassword(
        email: savedUser.user.email,
        password: savedUser.password!,
      )
          .catchError((error) async {
        log('normal auth error: $error');
        await client.auth.signOut();
        await UserHelper.signOut();
        throw ex.AuthException(AppStrings.sessionExpired);
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
        log('provider auth error: $error');
        await client.auth.signOut();
        await UserHelper.signOut();
        throw ex.AuthException(AppStrings.sessionExpired);
      });
    }
    final User? user = response.session?.user;
    if (user == null) {
      await client.auth.signOut();
      await UserHelper.signOut();
      throw ex.AuthException(AppStrings.sessionExpired);
    }
    final Map<String, dynamic> data =
        await client.from('users').select('*').eq('id', user.id).single();

    if (data.isEmpty) {
      await client.auth.signOut();
      await UserHelper.signOut();
      throw ex.AuthException(AppStrings.invalidCredentials);
    }
    await UserHelper.signOut();
    final UserModel signedUser = UserModel.fromJson(data);
    await UserHelper.signIn(signedUser);
  }
}

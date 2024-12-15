import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
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
      throw ex.NetworkException('Check your internet connection');
    }
    await client.auth.signOut().catchError(
          (error) => throw ex.ServerException('Something went wrong'),
        );
    await UserHelper.signOut();
  }

  @override
  Future<void> switchAccount(SavedUser savedUser) async {
    final bool isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException('Check your internet connection');
    }
    // await client.auth.signOut().catchError(
    //       (error) => throw ex.ServerException('Something went wrong'),
    //     );

    late final AuthResponse response;
    if (savedUser.password != null) {
      response = await client.auth
          .signInWithPassword(
        email: savedUser.user.email,
        password: savedUser.password!,
      )
          .catchError((error) {
        log('normal auth error: $error');
        throw ex.AuthException('Invalid credentials');
      });
    }

    if (savedUser.provider != null) {
      response = await client.auth
          .signInWithIdToken(
        provider: OAuthProvider.values.byName(savedUser.provider!),
        idToken: savedUser.idToken!,
        accessToken: savedUser.accessToken,
      )
          .catchError((error) {
        log('provider auth error: $error');
        throw ex.AuthException('Invalid credentials');
      });
    }
    final User? user = response.session?.user;
    if (user == null) {
      throw ex.AuthException('Invalid credentials');
    }
    final Map<String, dynamic> data =
        await client.from('users').select('*').eq('id', user.id).single();

    if (data.isEmpty) {
      await client.auth.signOut();
      throw ex.AuthException('Invalid credentials');
    }
    await UserHelper.signOut();
    final UserModel signedUser = UserModel.fromJson(data);
    await UserHelper.signIn(signedUser);
  }
}

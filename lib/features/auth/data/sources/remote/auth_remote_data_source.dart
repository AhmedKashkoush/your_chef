import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/core/errors/exceptions.dart' as ex;
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/network_helper.dart';

import '../../models/user_model.dart';

abstract class IAuthRemoteDataSource {
  Future<UserModel> login(LoginOptions options);
  Future<UserModel> googleSignIn();
  Future<void> register(RegisterOptions options);
  Future<void> resetPassword(ResetPasswordOptions options);
}

class SupabaseAuthRemoteDataSource implements IAuthRemoteDataSource {
  final SupabaseClient client;
  final GoogleSignIn googleSignInProvider;

  const SupabaseAuthRemoteDataSource(this.client, this.googleSignInProvider);

  @override
  Future<UserModel> login(LoginOptions options) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException('Check your internet connection');
    }

    log('response.toString()');

    final AuthResponse response = await client.auth
        .signInWithPassword(
      email: options.email,
      password: options.password,
    )
        .catchError((error) {
      if (error is AuthException) {
        throw ex.AuthException('Invalid credentials');
      }
      throw ex.ServerException('Something went wrong');
    });
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

    return UserModel.fromJson(data);
  }

  @override
  Future<void> register(RegisterOptions options) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException('Check your internet connection');
    }

    final AuthResponse response = await client.auth
        .signUp(email: options.email, password: options.password, data: {
      'name': options.name,
      'address': options.address,
    }).catchError((error) {
      if (error is AuthException) {
        throw ex.AuthException('Invalid credentials');
      }
      throw ex.ServerException('Something went wrong');
    });

    final User? user = response.user;
    if (user == null) {
      throw ex.AuthException('Invalid credentials');
    }
    final UserModel data = UserModel(
      id: user.id,
      name: options.name,
      phone: options.phone,
      email: options.email,
      address: options.address,
      image: '',
    );
    await client.from('users').insert(data.toJson());
    await client.auth.signOut();
  }

  @override
  Future<void> resetPassword(ResetPasswordOptions options) async {}

  @override
  Future<UserModel> googleSignIn() async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException('Check your internet connection');
    }
    await googleSignInProvider.signOut();
    final GoogleSignInAccount? googleUser = await googleSignInProvider.signIn();
    if (googleUser == null) {
      throw ex.ServerException('Something went wrong');
    }
    final GoogleSignInAuthentication authentication =
        await googleUser.authentication;

    final String? idToken = authentication.idToken;
    final String? accessToken = authentication.accessToken;

    if (idToken == null || accessToken == null) {
      await googleSignInProvider.signOut();
      throw ex.AuthException('Invalid credentials');
    }

    final AuthResponse response = await client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    final User? user = response.session?.user;
    if (user == null) {
      await googleSignInProvider.signOut();
      throw ex.AuthException('Invalid credentials');
    }

    final Map<String, dynamic>? data =
        await client.from('users').select('*').eq('id', user.id).maybeSingle();

    if (data == null) {
      final UserModel data = UserModel(
        id: user.id,
        name: googleUser.displayName ?? '',
        phone: user.phone ?? '',
        email: user.email ?? '',
        address: '',
        image: googleUser.photoUrl ?? '',
      );
      await client.from('users').insert(data.toJson());
      final Map<String, dynamic> newData =
          await client.from('users').select('*').eq('id', user.id).single();
      return UserModel.fromJson(newData);
    }
    return UserModel.fromJson(data);
  }
}

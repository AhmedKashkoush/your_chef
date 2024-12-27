import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/core/constants/keys.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/errors/exceptions.dart' as ex;
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/core/utils/secure_storage_helper.dart';
import 'package:your_chef/features/auth/data/models/saved_user_model.dart';

import '../../models/user_model.dart';

abstract class IAuthRemoteDataSource {
  Future<SavedUserModel> login(LoginOptions options);
  Future<SavedUserModel> googleSignIn();
  Future<void> sendOtpCode(ResetPasswordOptions options);
  Future<void> verify(VerifyOtpOptions options);
  Future<String> register(RegisterOptions options);
  Future<void> resetPassword(ResetPasswordOptions options);
  Future<void> uploadProfilePhoto(UploadProfileOptions options);
}

class SupabaseAuthRemoteDataSource implements IAuthRemoteDataSource {
  final SupabaseClient client;
  final GoogleSignIn googleSignInProvider;

  const SupabaseAuthRemoteDataSource(this.client, this.googleSignInProvider);

  @override
  Future<SavedUserModel> login(LoginOptions options) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw const ex.NetworkException(AppStrings.checkYourInternetConnection);
    }

    final AuthResponse response = await client.auth
        .signInWithPassword(
      email: options.email,
      password: options.password,
    )
        .catchError((error) {
      if (error is AuthException) {
        throw const ex.AuthException(AppStrings.invalidCredentials);
      }
      throw const ex.ServerException(AppStrings.somethingWentWrong);
    });
    final User? user = response.session?.user;

    if (user == null) {
      throw const ex.AuthException(AppStrings.invalidCredentials);
    }

    final Map<String, dynamic> data =
        await client.from('users').select('*').eq('id', user.id).single();

    if (data.isEmpty) {
      await client.auth.signOut();
      throw const ex.AuthException(AppStrings.invalidCredentials);
    }

    final UserModel signedUser = UserModel.fromJson(data);
    final SavedUserModel savedUser = SavedUserModel(
      user: signedUser,
      password: options.password,
      lastLogin: DateTime.now(),
    );
    await _checkIfUserSaved(savedUser);

    return savedUser;
  }

  @override
  Future<String> register(RegisterOptions options) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw const ex.NetworkException(AppStrings.checkYourInternetConnection);
    }

    final AuthResponse response = await client.auth
        .signUp(email: options.email, password: options.password, data: {
      'name': options.name,
      'address': options.address,
    }).catchError((error) {
      if (error is AuthException) {
        throw const ex.AuthException(AppStrings.invalidCredentials);
      }
      throw const ex.ServerException(AppStrings.somethingWentWrong);
    });

    final User? user = response.user;
    if (user == null) {
      throw const ex.AuthException(AppStrings.invalidCredentials);
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
    return user.id;
  }

  @override
  Future<void> resetPassword(ResetPasswordOptions options) async {}

  @override
  Future<SavedUserModel> googleSignIn() async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw const ex.NetworkException(AppStrings.checkYourInternetConnection);
    }
    await googleSignInProvider.signOut();
    final GoogleSignInAccount? googleUser = await googleSignInProvider.signIn();
    if (googleUser == null) {
      throw const ex.ServerException(AppStrings.somethingWentWrong);
    }
    final GoogleSignInAuthentication authentication =
        await googleUser.authentication;

    final String? idToken = authentication.idToken;
    final String? accessToken = authentication.accessToken;

    if (idToken == null || accessToken == null) {
      await googleSignInProvider.signOut();
      throw const ex.AuthException(AppStrings.invalidCredentials);
    }

    final AuthResponse response = await client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    final User? user = response.session?.user;
    if (user == null) {
      await googleSignInProvider.signOut();
      throw const ex.AuthException(AppStrings.invalidCredentials);
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
      final UserModel signedUser = UserModel.fromJson(newData);
      final SavedUserModel savedUser = SavedUserModel(
        user: signedUser,
        accessToken: accessToken,
        idToken: idToken,
        provider: 'google',
        lastLogin: DateTime.now(),
      );
      await _checkIfUserSaved(savedUser);
      return savedUser;
    }
    final UserModel signedUser = UserModel.fromJson(data);
    final SavedUserModel savedUser = SavedUserModel(
      user: signedUser,
      accessToken: accessToken,
      idToken: idToken,
      provider: 'google',
      lastLogin: DateTime.now(),
    );
    await _checkIfUserSaved(savedUser);
    return savedUser;
  }

  @override
  Future<void> uploadProfilePhoto(UploadProfileOptions options) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw const ex.NetworkException(AppStrings.checkYourInternetConnection);
    }
    final String filename =
        '${options.uid}/${DateTime.now().millisecondsSinceEpoch}';

    await client.storage.from('avatars').upload(filename, options.photo);
    final String url = client.storage.from('avatars').getPublicUrl(filename);
    await client.from('users').update({"image": url}).eq('id', options.uid);
  }

  @override
  Future<void> sendOtpCode(ResetPasswordOptions options) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw const ex.NetworkException(AppStrings.checkYourInternetConnection);
    }

    await client.auth.signInWithOtp(
      email: options.email,
      phone: options.phone,
      shouldCreateUser: false,
      emailRedirectTo: null,
    );
  }

  @override
  Future<void> verify(VerifyOtpOptions options) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw const ex.NetworkException(AppStrings.checkYourInternetConnection);
    }
    await client.auth.verifyOTP(
      type: options.email != null ? OtpType.magiclink : OtpType.sms,
      token: options.otp,
      email: options.email,
      phone: options.phone,
    );
  }

  Future<void> _checkIfUserSaved(SavedUserModel savedUser) async {
    //TODO: Fix saved user refreshing issue
    final String? savedUsersData =
        await SecureStorageHelper.read(SharedPrefsKeys.savedUsers);

    final List<SavedUserModel> savedUsers = savedUsersData == null
        ? []
        : List<Map<String, dynamic>>.from(jsonDecode(savedUsersData) as List)
            .map(
            (user) {
              return SavedUserModel.fromJson(user);
            },
          ).toList();

    if (savedUsers.where((user) => user.user.id == savedUser.user.id).isEmpty) {
      return;
    }

    savedUsers.removeWhere((user) => user.user.id == savedUser.user.id);

    savedUsers.add(savedUser);

    await SecureStorageHelper.write(
        SharedPrefsKeys.savedUsers, jsonEncode(savedUsers));
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/core/errors/exceptions.dart' as ex;
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/network_helper.dart';

import '../../models/user_model.dart';

abstract class IAuthRemoteDataSource {
  Future<UserModel> login(LoginOptions options);
  Future<void> register(RegisterOptions options);
  Future<void> resetPassword(ResetPasswordOptions options);
}

class SupabaseAuthRemoteDataSource implements IAuthRemoteDataSource {
  final SupabaseClient client;

  const SupabaseAuthRemoteDataSource(this.client);

  @override
  Future<UserModel> login(LoginOptions options) async {
    if (!await NetworkHelper.isConnected) {
      throw ex.NetworkException('Check your internet connection');
    }

    final AuthResponse response = await client.auth.signInWithPassword(
      email: options.email,
      password: options.password,
    );
    final User? user = response.session?.user;

    if (user == null) {
      throw ex.AuthException('Invalid credentials');
    }

    final Map<String, dynamic> data =
        await client.from('users').select('*').eq('id', user.id).single();

    return UserModel.fromJson(data);
  }

  @override
  Future<void> register(RegisterOptions options) async {
    if (!await NetworkHelper.isConnected) {
      throw ex.NetworkException('Check your internet connection');
    }

    final AuthResponse response = await client.auth.signUp(
      email: options.email,
      password: options.password,
    );
    final User? user = response.session?.user;
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
  }

  @override
  Future<void> resetPassword(ResetPasswordOptions options) async {}
}

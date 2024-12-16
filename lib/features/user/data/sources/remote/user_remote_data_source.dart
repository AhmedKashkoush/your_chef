import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/user/data/models/saved_user_model.dart';
import 'package:your_chef/features/user/data/models/user_model.dart';

abstract class IUserRemoteDataSource {
  const IUserRemoteDataSource();
  Future<UserModel> getUser();
  Future<void> updateUser(UserOptions options);
  Future<void> deleteUser();
  Future<UserModel> switchUser(SavedUserModel user);
}

class SupabaseUserRemoteDataSource extends IUserRemoteDataSource {
  final SupabaseClient client;
  const SupabaseUserRemoteDataSource(this.client);

  @override
  Future<void> deleteUser() async {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<UserModel> getUser() async {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<UserModel> switchUser(SavedUserModel user) async {
    // TODO: implement switchUser
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser(UserOptions options) async {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}

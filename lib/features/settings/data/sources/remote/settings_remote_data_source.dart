import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/core/errors/exceptions.dart' as ex;
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/core/utils/user_helper.dart';

abstract class ISettingsRemoteDataSource {
  const ISettingsRemoteDataSource();

  Future<void> signOut();
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
}

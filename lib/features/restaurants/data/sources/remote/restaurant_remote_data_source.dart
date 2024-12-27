import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/errors/exceptions.dart' as ex;
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/features/restaurants/data/models/restaurant_model.dart';

abstract class IRestaurantRemoteDataSource {
  const IRestaurantRemoteDataSource();
  Future<List<RestaurantModel>> getPopularRestaurants();
}

class SupabaseRestaurantRemoteDataSource extends IRestaurantRemoteDataSource {
  final SupabaseClient client;

  const SupabaseRestaurantRemoteDataSource(this.client);

  @override
  Future<List<RestaurantModel>> getPopularRestaurants() async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw const ex.NetworkException(AppStrings.checkYourInternetConnection);
    }
    await Future.delayed(const Duration(seconds: 4));
    return AppDummies.restaurants.take(5).toList()..shuffle();
  }
}

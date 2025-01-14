import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/errors/exceptions.dart' as ex;
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/features/restaurants/data/models/restaurant_model.dart';

abstract class IRestaurantRemoteDataSource {
  const IRestaurantRemoteDataSource();
  Future<List<RestaurantModel>> getPopularRestaurants(
      PaginationOptions options);
  Future<List<RestaurantModel>> getRestaurants(PaginationOptions options);
}

class SupabaseRestaurantRemoteDataSource extends IRestaurantRemoteDataSource {
  final SupabaseClient client;

  const SupabaseRestaurantRemoteDataSource(this.client);

  @override
  Future<List<RestaurantModel>> getPopularRestaurants(
      PaginationOptions options) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    await Future.delayed(const Duration(seconds: 4));
    return AppDummies.restaurants.take(options.limit).toList()..shuffle();
  }

  @override
  Future<List<RestaurantModel>> getRestaurants(
      PaginationOptions options) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    await Future.delayed(const Duration(seconds: 4));
    return AppDummies.restaurants
        .skip((options.page - 1) * options.limit)
        .take(options.limit)
        .toList();
  }
}

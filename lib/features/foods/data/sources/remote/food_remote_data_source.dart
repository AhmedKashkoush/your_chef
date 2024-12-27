import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/errors/exceptions.dart' as ex;
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/features/foods/data/models/food_model.dart';

abstract class IFoodRemoteDataSource {
  const IFoodRemoteDataSource();
  Future<List<FoodModel>> getPopularFoods();
  Future<List<FoodModel>> getOnSaleFoods();
  Future<List<FoodModel>> getRestaurantFoods(RestaurantOptions options);
}

class SupabaseFoodRemoteDataSource extends IFoodRemoteDataSource {
  final SupabaseClient client;
  const SupabaseFoodRemoteDataSource(this.client);

  @override
  Future<List<FoodModel>> getPopularFoods() async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw const ex.NetworkException(AppStrings.checkYourInternetConnection);
    }
    await Future.delayed(const Duration(seconds: 4));
    return AppDummies.foods
        .where((food) => food.trending && food.sale == 0)
        .take(6)
        .toList()
      ..shuffle();
  }

  @override
  Future<List<FoodModel>> getOnSaleFoods() async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw const ex.NetworkException(AppStrings.checkYourInternetConnection);
    }
    await Future.delayed(const Duration(seconds: 4));
    return AppDummies.foods.where((food) => food.sale > 0).take(6).toList()
      ..shuffle();
  }

  @override
  Future<List<FoodModel>> getRestaurantFoods(RestaurantOptions options) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw const ex.NetworkException(AppStrings.checkYourInternetConnection);
    }
    await Future.delayed(const Duration(seconds: 4));
    return AppDummies.foods
        .where((food) => food.restaurant.id == options.restaurant.id)
        .toList();
  }
}

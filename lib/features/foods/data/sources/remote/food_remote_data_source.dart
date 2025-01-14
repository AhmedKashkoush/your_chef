import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/errors/exceptions.dart' as ex;
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/features/categories/data/models/category_model.dart';
import 'package:your_chef/features/foods/data/models/food_model.dart';

abstract class IFoodRemoteDataSource {
  const IFoodRemoteDataSource();
  Future<List<FoodModel>> getPopularFoods(PaginationOptions options);
  Future<List<FoodModel>> getOnSaleFoods(PaginationOptions options);
  Future<List<FoodModel>> getFoodsByCategory(
      PaginationOptions<CategoryModel> options);
  Future<List<FoodModel>> getRestaurantFoods(RestaurantOptions options);
}

class SupabaseFoodRemoteDataSource extends IFoodRemoteDataSource {
  final SupabaseClient client;
  const SupabaseFoodRemoteDataSource(this.client);

  @override
  Future<List<FoodModel>> getPopularFoods(PaginationOptions options) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    await Future.delayed(const Duration(seconds: 4));
    return AppDummies.foods
        .where((food) => food.trending && food.sale == 0)
        .skip((options.page - 1) * options.limit)
        .take(options.limit)
        .toList()
      ..shuffle();
  }

  @override
  Future<List<FoodModel>> getOnSaleFoods(PaginationOptions options) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    await Future.delayed(const Duration(seconds: 4));
    return AppDummies.foods
        .where((food) => food.sale > 0)
        .skip((options.page - 1) * options.limit)
        .take(options.limit)
        .toList()
      ..shuffle();
  }

  @override
  Future<List<FoodModel>> getRestaurantFoods(RestaurantOptions options) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    await Future.delayed(const Duration(seconds: 4));

    return AppDummies.foods
        .where((food) => food.restaurant.id == options.restaurant.id)
        .toList();
  }

  @override
  Future<List<FoodModel>> getFoodsByCategory(PaginationOptions options) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    await Future.delayed(const Duration(seconds: 4));
    return AppDummies.foods
        .where((food) => food.category.id == options.model!.id)
        .skip((options.page - 1) * options.limit)
        .take(options.limit)
        .toList();
  }
}

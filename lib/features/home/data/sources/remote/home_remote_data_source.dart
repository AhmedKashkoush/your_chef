import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/errors/exceptions.dart' as ex;
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/features/categories/data/models/category_model.dart';
import 'package:your_chef/features/offers/data/models/offer_model.dart';
import 'package:your_chef/features/foods/data/models/food_model.dart';
import 'package:your_chef/features/restaurants/data/models/restaurant_model.dart';

abstract class IHomeRemoteDataSource {
  const IHomeRemoteDataSource();
  Future<List<OfferModel>> getOffers();
  Future<List<CategoryModel>> getCategories();
  Future<List<RestaurantModel>> getRestaurants();
  Future<List<FoodModel>> getPopularFoods();
  Future<List<FoodModel>> getOnSaleFoods();
}

class SupabaseHomeRemoteDataSource extends IHomeRemoteDataSource {
  final SupabaseClient client;

  const SupabaseHomeRemoteDataSource(this.client);
  @override
  Future<List<CategoryModel>> getCategories() async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw const ex.NetworkException(AppStrings.checkYourInternetConnection);
    }
    await Future.delayed(const Duration(seconds: 4));
    return AppDummies.categories.take(5).toList();
  }

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
  Future<List<RestaurantModel>> getRestaurants() async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw const ex.NetworkException(AppStrings.checkYourInternetConnection);
    }
    await Future.delayed(const Duration(seconds: 4));
    return AppDummies.restaurants.take(5).toList()..shuffle();
  }

  @override
  Future<List<OfferModel>> getOffers() async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw const ex.NetworkException(AppStrings.checkYourInternetConnection);
    }
    await Future.delayed(const Duration(seconds: 4));
    return AppDummies.offers..shuffle();
  }
}

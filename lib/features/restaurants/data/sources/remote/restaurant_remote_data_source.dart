import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/errors/exceptions.dart' as ex;
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/features/offers/data/models/offer_model.dart';
import 'package:your_chef/features/foods/data/models/food_model.dart';

abstract class IRestaurantRemoteDataSource {
  const IRestaurantRemoteDataSource();
  Future<List<FoodModel>> getMenu(RestaurantOptions options);
  Future<List<OfferModel>> getOffers(RestaurantOptions options);
}

class SupabaseRestaurantRemoteDataSource extends IRestaurantRemoteDataSource {
  final SupabaseClient client;

  const SupabaseRestaurantRemoteDataSource(this.client);

  @override
  Future<List<FoodModel>> getMenu(RestaurantOptions options) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection);
    }
    await Future.delayed(const Duration(seconds: 4));
    return AppDummies.foods
        .where((food) => food.restaurant.id == options.restaurant.id)
        .toList();
  }

  @override
  Future<List<OfferModel>> getOffers(RestaurantOptions options) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection);
    }
    await Future.delayed(const Duration(seconds: 4));
    return AppDummies.offers
        .where((offer) => offer.restaurant.id == options.restaurant.id)
        .toList();
  }
}

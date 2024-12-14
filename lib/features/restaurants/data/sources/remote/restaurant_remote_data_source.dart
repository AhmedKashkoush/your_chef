import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/errors/exceptions.dart' as ex;
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/features/home/data/models/offer_model.dart';
import 'package:your_chef/features/home/data/models/product_model.dart';

abstract class IRestaurantRemoteDataSource {
  const IRestaurantRemoteDataSource();
  Future<List<ProductModel>> getMenu(RestaurantOptions options);
  Future<List<OfferModel>> getOffers(RestaurantOptions options);
}

class SupabaseRestaurantRemoteDataSource extends IRestaurantRemoteDataSource {
  final SupabaseClient client;

  const SupabaseRestaurantRemoteDataSource(this.client);

  @override
  Future<List<ProductModel>> getMenu(RestaurantOptions options) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException('Check your internet connection');
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
      throw ex.NetworkException('Check your internet connection');
    }
    await Future.delayed(const Duration(seconds: 4));
    return AppDummies.offers
        .where((offer) => offer.restaurant.id == options.restaurant.id)
        .toList();
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/errors/exceptions.dart' as ex;
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/features/offers/data/models/offer_model.dart';

abstract class IOfferRemoteDataSource {
  const IOfferRemoteDataSource();
  Future<List<OfferModel>> getOffers();
  Future<List<OfferModel>> getRestaurantOffers(RestaurantOptions options);
}

class SupabaseOfferRemoteDataSource extends IOfferRemoteDataSource {
  final SupabaseClient client;
  const SupabaseOfferRemoteDataSource(this.client);
  @override
  Future<List<OfferModel>> getOffers() async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw const ex.NetworkException(AppStrings.checkYourInternetConnection);
    }
    await Future.delayed(const Duration(seconds: 4));
    return AppDummies.offers..shuffle();
  }

  @override
  Future<List<OfferModel>> getRestaurantOffers(
      RestaurantOptions options) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw const ex.NetworkException(AppStrings.checkYourInternetConnection);
    }
    await Future.delayed(const Duration(seconds: 4));
    return AppDummies.offers
        .where((offer) => offer.restaurant.id == options.restaurant.id)
        .toList();
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/core/errors/exceptions.dart' as ex;
import 'package:your_chef/features/foods/data/models/food_model.dart';

abstract class IWishlistRemoteDataSource {
  const IWishlistRemoteDataSource();
  Future<void> addProductToWishlist(FoodModel food);
  Future<void> removeProductFromWishlist(FoodModel food);
  // Future<bool> isProductInWishlist(ProductModel product);

  Future<List<FoodModel>> getProductsWishList(
    PaginationOptions options,
  );
}

class SupabaseWishlistRemoteDataSource implements IWishlistRemoteDataSource {
  final SupabaseClient client;

  const SupabaseWishlistRemoteDataSource(this.client);

  @override
  Future<void> addProductToWishlist(FoodModel food) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    await Future.delayed(const Duration(seconds: 1));
    AppDummies.foodsWishlist.add(food);
  }

  @override
  Future<List<FoodModel>> getProductsWishList(PaginationOptions options) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    await Future.delayed(const Duration(seconds: 4));

    return AppDummies.foodsWishlist
        .sublist(
          (options.page - 1) * options.limit,
        )
        .take(options.limit)
        .toList();
  }

  // @override
  // Future<bool> isProductInWishlist(ProductModel product) async {
  //   final isConnected = await NetworkHelper.isConnected;
  //   if (!isConnected) {
  //     throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
  //   }
  //   await Future.delayed(const Duration(seconds: 4));
  //   return AppDummies.foodsWishlist.contains(product);
  // }

  @override
  Future<void> removeProductFromWishlist(FoodModel food) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    await Future.delayed(const Duration(seconds: 1));
    AppDummies.foodsWishlist.remove(food);
  }
}

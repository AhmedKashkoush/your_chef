import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/core/errors/exceptions.dart' as ex;
import 'package:your_chef/features/home/data/models/product_model.dart';

abstract class IWishlistRemoteDataSource {
  const IWishlistRemoteDataSource();
  Future<void> addProductToWishlist(ProductModel product);
  Future<void> removeProductFromWishlist(ProductModel product);
  // Future<bool> isProductInWishlist(ProductModel product);

  Future<List<ProductModel>> getProductsWishList(
    PaginationOptions options,
  );
}

class SupabaseWishlistRemoteDataSource implements IWishlistRemoteDataSource {
  final SupabaseClient client;

  const SupabaseWishlistRemoteDataSource(this.client);

  @override
  Future<void> addProductToWishlist(ProductModel product) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException('Check your internet connection');
    }
    await Future.delayed(const Duration(seconds: 1));
    AppDummies.foodsWishlist.add(product);
  }

  @override
  Future<List<ProductModel>> getProductsWishList(
      PaginationOptions options) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException('Check your internet connection');
    }
    await Future.delayed(const Duration(seconds: 4));
    log(AppDummies.foodsWishlist.length.toString());
    log(((options.page - 1)).toString());
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
  //     throw ex.NetworkException('Check your internet connection');
  //   }
  //   await Future.delayed(const Duration(seconds: 4));
  //   return AppDummies.foodsWishlist.contains(product);
  // }

  @override
  Future<void> removeProductFromWishlist(ProductModel product) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException('Check your internet connection');
    }
    await Future.delayed(const Duration(seconds: 1));
    AppDummies.foodsWishlist.remove(product);
  }
}

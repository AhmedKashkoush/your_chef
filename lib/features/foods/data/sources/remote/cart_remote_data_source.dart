import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/errors/exceptions.dart' as ex;
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/features/foods/data/models/cart_item_model.dart';
import 'package:your_chef/features/foods/data/models/food_model.dart';

abstract class ICartRemoteDataSource {
  const ICartRemoteDataSource();
  Future<void> addProductToCart(FoodModel food);
  Future<void> removeProductFromCart(FoodModel food);
  Future<void> increment(CartItemModel item);
  Future<void> decrement(CartItemModel item);
  Future<List<CartItemModel>> getCart();
  Future<void> emptyCart();
  Future<num> getTotal();
  Future<num> getFees();
}

class SupabaseCartRemoteDataSource implements ICartRemoteDataSource {
  final SupabaseClient client;

  const SupabaseCartRemoteDataSource(this.client);

  @override
  Future<void> addProductToCart(FoodModel food) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    await Future.delayed(const Duration(seconds: 1));
    final hasStock =
        AppDummies.foods.where((food) => food.id == food.id).first.stock >= 1;
    if (!hasStock) {
      throw ex.ServerException(AppStrings.outOfStock.tr());
    }
    AppDummies.cart.add(
        CartItemModel(id: AppDummies.cart.length, food: food, quantity: 1));
  }

  @override
  Future<List<CartItemModel>> getCart() async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    await Future.delayed(const Duration(seconds: 4));

    return AppDummies.cart;
  }

  @override
  Future<void> removeProductFromCart(FoodModel food) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    await Future.delayed(const Duration(seconds: 1));
    await Future.delayed(const Duration(seconds: 1));
    final hasStock =
        AppDummies.foods.where((food) => food.id == food.id).first.stock >= 1;
    if (!hasStock) {
      throw ex.ServerException(AppStrings.outOfStock.tr());
    }
    AppDummies.cart.removeWhere((cartItem) => cartItem.food.id == food.id);
  }

  @override
  Future<void> decrement(CartItemModel item) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    await Future.delayed(const Duration(seconds: 1));
    final hasStock =
        AppDummies.foods.where((food) => food.id == item.food.id).first.stock >=
            item.quantity;
    if (!hasStock) {
      throw ex.ServerException(AppStrings.outOfStock.tr());
    }
    AppDummies.cart
      ..removeWhere((cartItem) => cartItem.id == item.id)
      ..add(item);
  }

  @override
  Future<void> emptyCart() async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    await Future.delayed(const Duration(seconds: 1));
    AppDummies.cart.clear();
  }

  @override
  Future<num> getTotal() async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    await Future.delayed(const Duration(seconds: 1));
    num total = 0;
    for (var item in AppDummies.cart) {
      total += item.food.price * item.quantity;
    }
    return total;
  }

  @override
  Future<num> getFees() async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    await Future.delayed(const Duration(seconds: 1));
    num fees = 0;
    for (var item in AppDummies.cart) {
      fees += item.food.fees * item.quantity;
    }
    return fees;
  }

  @override
  Future<void> increment(CartItemModel item) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw ex.NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    await Future.delayed(const Duration(seconds: 1));
    final hasStock =
        AppDummies.foods.where((food) => food.id == item.food.id).first.stock >=
            item.quantity;
    if (!hasStock) {
      throw ex.ServerException(AppStrings.outOfStock.tr());
    }
    AppDummies.cart
      ..removeWhere((cartItem) => cartItem.id == item.id)
      ..add(item);
  }
}

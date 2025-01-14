import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/errors/exceptions.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/features/categories/data/models/category_model.dart';

abstract class ICategoryRemoteDataSource {
  const ICategoryRemoteDataSource();
  Future<List<CategoryModel>> getCategories(GetCategoriesOptions options);
  Future<List<CategoryModel>> getAllCategories();
}

class SupabaseCategoryRemoteDataSource extends ICategoryRemoteDataSource {
  final SupabaseClient client;
  const SupabaseCategoryRemoteDataSource(this.client);

  @override
  Future<List<CategoryModel>> getCategories(
      GetCategoriesOptions options) async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    await Future.delayed(const Duration(seconds: 4));
    return AppDummies.categories.take(options.limit).toList();
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final isConnected = await NetworkHelper.isConnected;
    if (!isConnected) {
      throw NetworkException(AppStrings.checkYourInternetConnection.tr());
    }
    await Future.delayed(const Duration(seconds: 4));
    return AppDummies.categories;
  }
}

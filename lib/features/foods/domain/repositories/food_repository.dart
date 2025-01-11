import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/categories/domain/entities/category.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';

abstract class IFoodRepository {
  const IFoodRepository();
  Future<Either<Failure, List<Food>>> getPopularFoods(
      PaginationOptions options);
  Future<Either<Failure, List<Food>>> getOnSaleFoods(PaginationOptions options);
  Future<Either<Failure, List<Food>>> getFoodsByCategory(
      PaginationOptions<Category> options);
  Future<Either<Failure, List<Food>>> getRestaurantFoods(
      RestaurantOptions options);
}

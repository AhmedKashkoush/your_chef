import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/features/categories/domain/entities/category.dart';
import 'package:your_chef/features/offers/domain/entities/offer.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';

abstract class IHomeRepository {
  const IHomeRepository();
  Future<Either<Failure, List<Offer>>> getOffers();
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, List<Restaurant>>> getRestaurants();
  Future<Either<Failure, List<Food>>> getPopularFoods();
  Future<Either<Failure, List<Food>>> getOnSaleFoods();
}

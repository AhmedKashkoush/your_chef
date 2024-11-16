import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/features/home/domain/entities/category.dart';
import 'package:your_chef/features/home/domain/entities/offer.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';
import 'package:your_chef/features/home/domain/entities/restaurant.dart';

abstract class IHomeRepository {
  const IHomeRepository();
  Future<Either<Failure, List<Offer>>> getOffers();
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, List<Restaurant>>> getRestaurants();
  Future<Either<Failure, List<Product>>> getPopularProducts();
  Future<Either<Failure, List<Product>>> getOnSaleProducts();
}

import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/offers/domain/entities/offer.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';

abstract class IRestaurantRepository {
  const IRestaurantRepository();

  Future<Either<Failure, List<Food>>> getMenu(RestaurantOptions options);
  Future<Either<Failure, List<Offer>>> getOffers(RestaurantOptions options);
}

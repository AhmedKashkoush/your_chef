import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/home/domain/entities/offer.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';

abstract class IRestaurantRepository {
  const IRestaurantRepository();

  Future<Either<Failure, List<Product>>> getMenu(RestaurantOptions options);
  Future<Either<Failure, List<Offer>>> getOffers(RestaurantOptions options);
}

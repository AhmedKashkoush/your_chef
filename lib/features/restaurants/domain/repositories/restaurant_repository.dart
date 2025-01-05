import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';

abstract class IRestaurantRepository {
  const IRestaurantRepository();
  Future<Either<Failure, List<Restaurant>>> getPopularRestaurants(
    PaginationOptions options,
  );
  Future<Either<Failure, List<Restaurant>>> getRestaurants(
    PaginationOptions options,
  );
}

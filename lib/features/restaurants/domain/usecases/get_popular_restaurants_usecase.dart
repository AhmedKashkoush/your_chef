import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';
import 'package:your_chef/features/restaurants/domain/repositories/restaurant_repository.dart';

class GetPopularRestaurantsUseCase extends NoParamsUseCase<List<Restaurant>> {
  final IRestaurantRepository repository;

  const GetPopularRestaurantsUseCase(this.repository);
  @override
  Future<Either<Failure, List<Restaurant>>> call() {
    return repository.getPopularRestaurants();
  }
}
import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';
import 'package:your_chef/features/home/domain/repositories/home_repository.dart';

class GetRestaurantsUseCase extends NoParamsUseCase<List<Restaurant>> {
  final IHomeRepository repository;

  const GetRestaurantsUseCase(this.repository);
  @override
  Future<Either<Failure, List<Restaurant>>> call() {
    return repository.getRestaurants();
  }
}

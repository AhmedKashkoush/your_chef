import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/restaurants/domain/repositories/restaurant_repository.dart';

class GetRestaurantMenuUseCase extends UseCase<List<Food>, RestaurantOptions> {
  final IRestaurantRepository repository;

  const GetRestaurantMenuUseCase(this.repository);
  @override
  Future<Either<Failure, List<Food>>> call(RestaurantOptions params) {
    return repository.getMenu(params);
  }
}

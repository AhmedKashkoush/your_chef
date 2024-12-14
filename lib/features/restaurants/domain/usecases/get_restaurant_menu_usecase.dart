import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';
import 'package:your_chef/features/restaurants/domain/repositories/restaurant_repository.dart';

class GetRestaurantMenuUseCase
    extends UseCase<List<Product>, RestaurantOptions> {
  final IRestaurantRepository repository;

  const GetRestaurantMenuUseCase(this.repository);
  @override
  Future<Either<Failure, List<Product>>> call(RestaurantOptions params) {
    return repository.getMenu(params);
  }
}

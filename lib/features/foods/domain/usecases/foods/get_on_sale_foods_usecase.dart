import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/foods/domain/repositories/food_repository.dart';

class GetOnSaleFoodsUseCase extends NoParamsUseCase<List<Food>> {
  final IFoodRepository repository;

  const GetOnSaleFoodsUseCase(this.repository);
  @override
  Future<Either<Failure, List<Food>>> call() {
    return repository.getOnSaleFoods();
  }
}

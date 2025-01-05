import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/foods/domain/repositories/food_repository.dart';

class GetPopularFoodsUseCase extends UseCase<List<Food>, PaginationOptions> {
  final IFoodRepository repository;

  const GetPopularFoodsUseCase(this.repository);
  @override
  Future<Either<Failure, List<Food>>> call(PaginationOptions params) {
    return repository.getPopularFoods(params);
  }
}

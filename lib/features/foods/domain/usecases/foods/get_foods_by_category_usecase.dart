import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/categories/domain/entities/category.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/foods/domain/repositories/food_repository.dart';

class GetFoodsByCategoryUseCase
    extends UseCase<List<Food>, PaginationOptions<Category>> {
  final IFoodRepository repository;

  const GetFoodsByCategoryUseCase(this.repository);
  @override
  Future<Either<Failure, List<Food>>> call(PaginationOptions<Category> params) {
    return repository.getFoodsByCategory(params);
  }
}

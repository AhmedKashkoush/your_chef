import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/categories/domain/entities/category.dart';
import 'package:your_chef/features/home/domain/repositories/home_repository.dart';

class GetCategoriesUseCase extends NoParamsUseCase<List<Category>> {
  final IHomeRepository repository;

  const GetCategoriesUseCase(this.repository);
  @override
  Future<Either<Failure, List<Category>>> call() {
    return repository.getCategories();
  }
}

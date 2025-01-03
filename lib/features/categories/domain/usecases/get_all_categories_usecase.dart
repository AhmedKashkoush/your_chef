import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/categories/domain/entities/category.dart';
import 'package:your_chef/features/categories/domain/repositories/category_repository.dart';

class GetAllCategoriesUseCase extends NoParamsUseCase<List<Category>> {
  final ICategoryRepository repository;

  const GetAllCategoriesUseCase(this.repository);
  @override
  Future<Either<Failure, List<Category>>> call() {
    return repository.getAllCategories();
  }
}

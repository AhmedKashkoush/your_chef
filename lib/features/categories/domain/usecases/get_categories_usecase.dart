import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/categories/domain/entities/category.dart';
import 'package:your_chef/features/categories/domain/repositories/category_repository.dart';

class GetCategoriesUseCase
    extends UseCase<List<Category>, GetCategoriesOptions> {
  final ICategoryRepository repository;

  const GetCategoriesUseCase(this.repository);
  @override
  Future<Either<Failure, List<Category>>> call(GetCategoriesOptions params) {
    return repository.getCategories(params);
  }
}

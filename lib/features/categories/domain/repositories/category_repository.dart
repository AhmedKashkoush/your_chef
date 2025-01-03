import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/categories/domain/entities/category.dart';

abstract class ICategoryRepository {
  const ICategoryRepository();
  //
  Future<Either<Failure, List<Category>>> getCategories(
    GetCategoriesOptions options,
  );
  Future<Either<Failure, List<Category>>> getAllCategories();
}

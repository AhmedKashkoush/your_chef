import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/exceptions.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/categories/data/models/category_model.dart';
import 'package:your_chef/features/categories/data/sources/remote/category_remote_data_source.dart';
import 'package:your_chef/features/categories/domain/entities/category.dart';
import 'package:your_chef/features/categories/domain/repositories/category_repository.dart';

class CategoryRepository extends ICategoryRepository {
  final ICategoryRemoteDataSource remoteDataSource;

  const CategoryRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Category>>> getCategories(
      GetCategoriesOptions options) async {
    try {
      final List<CategoryModel> categories =
          await remoteDataSource.getCategories(options);
      return Right(categories.map((category) => category.toEntity()).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/exceptions.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/foods/data/models/food_model.dart';
import 'package:your_chef/features/foods/data/sources/remote/food_remote_data_source.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/foods/domain/repositories/food_repository.dart';

class FoodRepository extends IFoodRepository {
  final IFoodRemoteDataSource remoteDataSource;
  const FoodRepository(this.remoteDataSource);
  @override
  Future<Either<Failure, List<Food>>> getPopularFoods() async {
    try {
      final List<FoodModel> foods = await remoteDataSource.getPopularFoods();
      return Right(foods.map((food) => food.toEntity()).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Food>>> getOnSaleFoods() async {
    try {
      final List<FoodModel> foods = await remoteDataSource.getOnSaleFoods();
      return Right(foods.map((food) => food.toEntity()).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Food>>> getRestaurantFoods(
      RestaurantOptions options) async {
    try {
      final List<FoodModel> foods =
          await remoteDataSource.getRestaurantFoods(options);
      return Right(foods.map((food) => food.toEntity()).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

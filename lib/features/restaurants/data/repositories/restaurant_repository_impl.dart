import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/exceptions.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/restaurants/data/models/restaurant_model.dart';
import 'package:your_chef/features/restaurants/data/sources/remote/restaurant_remote_data_source.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';
import 'package:your_chef/features/restaurants/domain/repositories/restaurant_repository.dart';

class RestaurantRepository implements IRestaurantRepository {
  final IRestaurantRemoteDataSource remoteDataSource;

  const RestaurantRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Restaurant>>> getPopularRestaurants(
      PaginationOptions options) async {
    try {
      final List<RestaurantModel> restaurants =
          await remoteDataSource.getPopularRestaurants(options);
      return Right(
          restaurants.map((restaurant) => restaurant.toEntity()).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Restaurant>>> getRestaurants(
      PaginationOptions options) async {
    try {
      final List<RestaurantModel> restaurants =
          await remoteDataSource.getRestaurants(options);
      return Right(
          restaurants.map((restaurant) => restaurant.toEntity()).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

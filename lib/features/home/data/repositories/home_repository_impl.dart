import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/exceptions.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/features/categories/data/models/category_model.dart';
import 'package:your_chef/features/offers/data/models/offer_model.dart';
import 'package:your_chef/features/foods/data/models/food_model.dart';
import 'package:your_chef/features/restaurants/data/models/restaurant_model.dart';
import 'package:your_chef/features/home/data/sources/remote/home_remote_data_source.dart';
import 'package:your_chef/features/categories/domain/entities/category.dart';
import 'package:your_chef/features/offers/domain/entities/offer.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';
import 'package:your_chef/features/home/domain/repositories/home_repository.dart';

class HomeRepository extends IHomeRepository {
  final IHomeRemoteDataSource remoteDataSource;

  const HomeRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final List<CategoryModel> categories =
          await remoteDataSource.getCategories();
      return Right(categories.map((category) => category.toEntity()).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

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
  Future<Either<Failure, List<Restaurant>>> getRestaurants() async {
    try {
      final List<RestaurantModel> restaurants =
          await remoteDataSource.getRestaurants();
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
  Future<Either<Failure, List<Offer>>> getOffers() async {
    try {
      final List<OfferModel> offers = await remoteDataSource.getOffers();
      return Right(offers.map((offer) => offer.toEntity()).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

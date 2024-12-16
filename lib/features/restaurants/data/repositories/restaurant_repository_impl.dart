import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/exceptions.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/offers/data/models/offer_model.dart';
import 'package:your_chef/features/foods/data/models/food_model.dart';
import 'package:your_chef/features/offers/domain/entities/offer.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/restaurants/data/sources/remote/restaurant_remote_data_source.dart';
import 'package:your_chef/features/restaurants/domain/repositories/restaurant_repository.dart';

class RestaurantRepository implements IRestaurantRepository {
  final IRestaurantRemoteDataSource remoteDataSource;

  const RestaurantRepository(this.remoteDataSource);
  @override
  Future<Either<Failure, List<Food>>> getMenu(RestaurantOptions options) async {
    try {
      final List<FoodModel> foods = await remoteDataSource.getMenu(options);
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
  Future<Either<Failure, List<Offer>>> getOffers(
      RestaurantOptions options) async {
    try {
      final List<OfferModel> offers = await remoteDataSource.getOffers(options);
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

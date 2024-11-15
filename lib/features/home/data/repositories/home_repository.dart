import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/exceptions.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/features/home/data/models/category_model.dart';
import 'package:your_chef/features/home/data/models/offer_model.dart';
import 'package:your_chef/features/home/data/models/product_model.dart';
import 'package:your_chef/features/home/data/models/restaurant_model.dart';
import 'package:your_chef/features/home/data/sources/remote/home_remote_data_source.dart';
import 'package:your_chef/features/home/domain/entities/category.dart';
import 'package:your_chef/features/home/domain/entities/offer.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';
import 'package:your_chef/features/home/domain/entities/restaurant.dart';
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
    } on NetworkException {
      return const Left(NetworkFailure('Check your internet connection'));
    } on ServerException {
      return const Left(ServerFailure('Server Failure'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final List<ProductModel> products = await remoteDataSource.getProducts();
      return Right(products.map((product) => product.toEntity()).toList());
    } on NetworkException {
      return const Left(NetworkFailure('Check your internet connection'));
    } on ServerException {
      return const Left(ServerFailure('Server Failure'));
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
    } on NetworkException {
      return const Left(NetworkFailure('Check your internet connection'));
    } on ServerException {
      return const Left(ServerFailure('Server Failure'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Offer>>> getOffers() async {
    try {
      final List<OfferModel> offers = await remoteDataSource.getOffers();
      return Right(offers.map((offer) => offer.toEntity()).toList());
    } on NetworkException {
      return const Left(NetworkFailure('Check your internet connection'));
    } on ServerException {
      return const Left(ServerFailure('Server Failure'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

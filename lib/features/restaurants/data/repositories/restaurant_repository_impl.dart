import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/exceptions.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/home/data/models/offer_model.dart';
import 'package:your_chef/features/home/data/models/product_model.dart';
import 'package:your_chef/features/home/domain/entities/offer.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';
import 'package:your_chef/features/restaurants/data/sources/remote/restaurant_remote_data_source.dart';
import 'package:your_chef/features/restaurants/domain/repositories/restaurant_repository.dart';

class RestaurantRepository implements IRestaurantRepository {
  final IRestaurantRemoteDataSource remoteDataSource;

  const RestaurantRepository(this.remoteDataSource);
  @override
  Future<Either<Failure, List<Product>>> getMenu(
      RestaurantOptions options) async {
    try {
      final List<ProductModel> products =
          await remoteDataSource.getMenu(options);
      return Right(products.map((product) => product.toEntity()).toList());
    } on NetworkException {
      return const Left(NetworkFailure('Check your internet connection'));
    } on ServerException {
      return const Left(ServerFailure('Server error'));
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
    } on NetworkException {
      return const Left(NetworkFailure('Check your internet connection'));
    } on ServerException {
      return const Left(ServerFailure('Server error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

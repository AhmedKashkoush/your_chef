import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/exceptions.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/offers/data/models/offer_model.dart';
import 'package:your_chef/features/offers/data/sources/remote/offer_remote_data_source.dart';
import 'package:your_chef/features/offers/domain/entities/offer.dart';
import 'package:your_chef/features/offers/domain/repositories/offer_repository.dart';

class OfferRepository extends IOfferRepository {
  final IOfferRemoteDataSource remoteDataSource;

  const OfferRepository(this.remoteDataSource);
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

  @override
  Future<Either<Failure, List<Offer>>> getRestaurantOffers(
      RestaurantOptions options) async {
    try {
      final List<OfferModel> offers =
          await remoteDataSource.getRestaurantOffers(options);
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

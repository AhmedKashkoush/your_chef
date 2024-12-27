import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/offers/domain/entities/offer.dart';

abstract class IOfferRepository {
  const IOfferRepository();
  Future<Either<Failure, List<Offer>>> getOffers();
  Future<Either<Failure, List<Offer>>> getRestaurantOffers(
    RestaurantOptions options,
  );
}

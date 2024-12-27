import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/offers/domain/entities/offer.dart';
import 'package:your_chef/features/offers/domain/repositories/offer_repository.dart';

class GetRestaurantOffersUseCase
    extends UseCase<List<Offer>, RestaurantOptions> {
  final IOfferRepository repository;

  const GetRestaurantOffersUseCase(this.repository);
  @override
  Future<Either<Failure, List<Offer>>> call(RestaurantOptions params) {
    return repository.getRestaurantOffers(params);
  }
}

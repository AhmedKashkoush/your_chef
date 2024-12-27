import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/offers/domain/entities/offer.dart';
import 'package:your_chef/features/offers/domain/repositories/offer_repository.dart';

class GetOffersUseCase extends NoParamsUseCase<List<Offer>> {
  final IOfferRepository repository;

  const GetOffersUseCase(this.repository);
  @override
  Future<Either<Failure, List<Offer>>> call() {
    return repository.getOffers();
  }
}

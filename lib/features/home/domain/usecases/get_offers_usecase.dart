import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/offers/domain/entities/offer.dart';
import 'package:your_chef/features/home/domain/repositories/home_repository.dart';

class GetOffersUseCase extends NoParamsUseCase<List<Offer>> {
  final IHomeRepository repository;

  const GetOffersUseCase(this.repository);
  @override
  Future<Either<Failure, List<Offer>>> call() {
    return repository.getOffers();
  }
}

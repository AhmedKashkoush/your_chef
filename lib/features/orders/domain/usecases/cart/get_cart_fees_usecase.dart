import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/orders/domain/repositories/cart_repository.dart';

class GetCartFeesUseCase extends NoParamsUseCase<num> {
  final ICartRepository repository;
  const GetCartFeesUseCase(this.repository);
  @override
  Future<Either<Failure, num>> call() {
    return repository.getFees();
  }
}

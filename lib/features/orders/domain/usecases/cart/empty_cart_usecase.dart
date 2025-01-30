import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/orders/domain/repositories/cart_repository.dart';

class EmptyCartUseCase extends NoParamsUseCase<Unit> {
  final ICartRepository repository;
  const EmptyCartUseCase(this.repository);
  @override
  Future<Either<Failure, Unit>> call() {
    return repository.emptyCart();
  }
}

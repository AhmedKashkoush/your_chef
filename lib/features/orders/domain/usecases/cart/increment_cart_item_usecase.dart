import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/orders/domain/entities/cart_item.dart';
import 'package:your_chef/features/orders/domain/repositories/cart_repository.dart';

class IncrementCartItemUseCase extends UseCase<Unit, CartItem> {
  final ICartRepository repository;
  const IncrementCartItemUseCase(this.repository);
  @override
  Future<Either<Failure, Unit>> call(CartItem params) {
    return repository.increment(params);
  }
}

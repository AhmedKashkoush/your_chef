import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/foods/domain/entities/cart_item.dart';
import 'package:your_chef/features/foods/domain/repositories/cart_repository.dart';

class DecrementCartItemUseCase extends UseCase<Unit, CartItem> {
  final ICartRepository repository;
  const DecrementCartItemUseCase(this.repository);
  @override
  Future<Either<Failure, Unit>> call(CartItem params) {
    return repository.decrement(params);
  }
}

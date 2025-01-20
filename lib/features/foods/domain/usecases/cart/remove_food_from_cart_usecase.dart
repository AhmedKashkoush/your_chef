import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/foods/domain/repositories/cart_repository.dart';

class RemoveFoodFromCartUseCase extends UseCase<Unit, Food> {
  final ICartRepository repository;
  const RemoveFoodFromCartUseCase(this.repository);
  @override
  Future<Either<Failure, Unit>> call(Food params) {
    return repository.removeProductFromCart(params);
  }
}

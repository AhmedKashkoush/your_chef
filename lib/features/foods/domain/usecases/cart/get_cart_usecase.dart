import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/foods/domain/entities/cart_item.dart';
import 'package:your_chef/features/foods/domain/repositories/cart_repository.dart';

class GetCartUseCase extends NoParamsUseCase<List<CartItem>> {
  final ICartRepository repository;
  const GetCartUseCase(this.repository);
  @override
  Future<Either<Failure, List<CartItem>>> call() {
    return repository.getCart();
  }
}

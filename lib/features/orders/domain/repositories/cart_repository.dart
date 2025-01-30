import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/features/orders/domain/entities/cart_item.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';

abstract class ICartRepository {
  const ICartRepository();
  Future<Either<Failure, Unit>> addProductToCart(Food food);
  Future<Either<Failure, Unit>> removeProductFromCart(Food food);
  Future<Either<Failure, Unit>> increment(CartItem item);
  Future<Either<Failure, Unit>> decrement(CartItem item);
  Future<Either<Failure, List<CartItem>>> getCart();
  Future<Either<Failure, Unit>> emptyCart();
  Future<Either<Failure, num>> getTotal();
  Future<Either<Failure, num>> getFees();
}

import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/foods/domain/repositories/wishlist_repository.dart';

class RemoveFoodFromWishlistUseCase extends UseCase<Unit, Food> {
  final IWishlistRepository repository;
  const RemoveFoodFromWishlistUseCase(this.repository);
  @override
  Future<Either<Failure, Unit>> call(Food params) {
    return repository.removeProductFromWishlist(params);
  }
}

import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/wishlist/domain/repositories/wishlist_repository.dart';

class AddFoodToWishlistUseCase extends UseCase<Unit, Food> {
  final IWishlistRepository repository;
  const AddFoodToWishlistUseCase(this.repository);
  @override
  Future<Either<Failure, Unit>> call(Food params) {
    return repository.addProductToWishlist(params);
  }
}

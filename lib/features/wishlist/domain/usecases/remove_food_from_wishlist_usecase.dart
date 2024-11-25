import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';
import 'package:your_chef/features/wishlist/domain/repositories/wishlist_repository.dart';

class RemoveFoodFromWishlistUseCase extends UseCase<Unit, Product> {
  final IWishlistRepository repository;
  const RemoveFoodFromWishlistUseCase(this.repository);
  @override
  Future<Either<Failure, Unit>> call(Product params) {
    return repository.removeProductFromWishlist(params);
  }
}

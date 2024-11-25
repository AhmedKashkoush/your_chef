import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';
import 'package:your_chef/features/wishlist/domain/repositories/wishlist_repository.dart';

class GetFoodsWishlistUseCase
    extends UseCase<List<Product>, PaginationOptions> {
  final IWishlistRepository repository;
  const GetFoodsWishlistUseCase(this.repository);
  @override
  Future<Either<Failure, List<Product>>> call(PaginationOptions params) {
    return repository.getProductsWishList(params);
  }
}

import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';

abstract class IWishlistRepository {
  const IWishlistRepository();
  Future<Either<Failure, Unit>> addProductToWishlist(Product product);
  Future<Either<Failure, Unit>> removeProductFromWishlist(Product product);
  // Future<Either<Failure, bool>> isProductInWishlist(Product product);
  Future<Either<Failure, List<Product>>> getProductsWishList(
    PaginationOptions options,
  );
}

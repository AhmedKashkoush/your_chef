import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';

abstract class IWishlistRepository {
  const IWishlistRepository();
  Future<Either<Failure, Unit>> addProductToWishlist(Food food);
  Future<Either<Failure, Unit>> removeProductFromWishlist(Food food);
  // Future<Either<Failure, bool>> isProductInWishlist(Product product);
  Future<Either<Failure, List<Food>>> getFoodsWishList(
    PaginationOptions options,
  );
}

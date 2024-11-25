import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/exceptions.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/home/data/models/product_model.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';
import 'package:your_chef/features/wishlist/data/sources/remote/wishlist_remote_data_source.dart';
import 'package:your_chef/features/wishlist/domain/repositories/wishlist_repository.dart';

class WishlistRepository extends IWishlistRepository {
  final IWishlistRemoteDataSource remoteDataSource;

  const WishlistRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, Unit>> addProductToWishlist(Product product) async {
    try {
      await remoteDataSource
          .addProductToWishlist(ProductModel.fromEntity(product));
      return const Right(unit);
    } on NetworkException {
      return const Left(NetworkFailure('Check your internet connection'));
    } on ServerException {
      return const Left(ServerFailure('Server Failure'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsWishList(
      PaginationOptions options) async {
    try {
      final List<ProductModel> products =
          await remoteDataSource.getProductsWishList(options);
      return Right(products.map((e) => e.toEntity()).toList());
    } on NetworkException {
      return const Left(NetworkFailure('Check your internet connection'));
    } on ServerException {
      return const Left(ServerFailure('Server Failure'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeProductFromWishlist(
      Product product) async {
    try {
      await remoteDataSource
          .removeProductFromWishlist(ProductModel.fromEntity(product));
      return const Right(unit);
    } on NetworkException {
      return const Left(NetworkFailure('Check your internet connection'));
    } on ServerException {
      return const Left(ServerFailure('Server Failure'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

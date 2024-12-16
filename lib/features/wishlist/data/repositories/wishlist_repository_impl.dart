import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/exceptions.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/foods/data/models/food_model.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/wishlist/data/sources/remote/wishlist_remote_data_source.dart';
import 'package:your_chef/features/wishlist/domain/repositories/wishlist_repository.dart';

class WishlistRepository extends IWishlistRepository {
  final IWishlistRemoteDataSource remoteDataSource;

  const WishlistRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, Unit>> addProductToWishlist(Food food) async {
    try {
      await remoteDataSource.addProductToWishlist(FoodModel.fromEntity(food));
      return const Right(unit);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Food>>> getFoodsWishList(
      PaginationOptions options) async {
    try {
      final List<FoodModel> foods =
          await remoteDataSource.getProductsWishList(options);
      return Right(foods.map((food) => food.toEntity()).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeProductFromWishlist(Food food) async {
    try {
      await remoteDataSource
          .removeProductFromWishlist(FoodModel.fromEntity(food));
      return const Right(unit);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

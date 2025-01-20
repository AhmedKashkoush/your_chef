import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/errors/exceptions.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/features/foods/data/models/cart_item_model.dart';
import 'package:your_chef/features/foods/data/models/food_model.dart';
import 'package:your_chef/features/foods/data/sources/remote/cart_remote_data_source.dart';
import 'package:your_chef/features/foods/domain/entities/cart_item.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/foods/domain/repositories/cart_repository.dart';

class CartRepository extends ICartRepository {
  final ICartRemoteDataSource remoteDataSource;

  const CartRepository(this.remoteDataSource);
  @override
  Future<Either<Failure, Unit>> addProductToCart(Food food) async {
    try {
      await remoteDataSource.addProductToCart(FoodModel.fromEntity(food));
      return const Right(unit);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(AppStrings.somethingWentWrong.tr()));
    }
  }

  @override
  Future<Either<Failure, Unit>> decrement(CartItem item) async {
    try {
      await remoteDataSource.decrement(CartItemModel.fromEntity(item));
      return const Right(unit);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(AppStrings.somethingWentWrong.tr()));
    }
  }

  @override
  Future<Either<Failure, Unit>> emptyCart() async {
    try {
      await remoteDataSource.emptyCart();
      return const Right(unit);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(AppStrings.somethingWentWrong.tr()));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> getCart() async {
    try {
      final List<CartItemModel> cartItems = await remoteDataSource.getCart();
      return Right(cartItems.map((item) => item.toEntity()).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(AppStrings.somethingWentWrong.tr()));
    }
  }

  @override
  Future<Either<Failure, num>> getTotal() async {
    try {
      final num total = await remoteDataSource.getTotal();
      return Right(total);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(AppStrings.somethingWentWrong.tr()));
    }
  }

  @override
  Future<Either<Failure, num>> getFees() async {
    try {
      final num fees = await remoteDataSource.getFees();
      return Right(fees);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(AppStrings.somethingWentWrong.tr()));
    }
  }

  @override
  Future<Either<Failure, Unit>> increment(CartItem item) async {
    try {
      await remoteDataSource.increment(CartItemModel.fromEntity(item));
      return const Right(unit);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(AppStrings.somethingWentWrong.tr()));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeProductFromCart(Food food) async {
    try {
      await remoteDataSource.removeProductFromCart(FoodModel.fromEntity(food));
      return const Right(unit);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(AppStrings.somethingWentWrong.tr()));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/errors/exceptions.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/user/data/models/saved_user_model.dart';
import 'package:your_chef/features/user/data/models/user_model.dart';
import 'package:your_chef/features/user/data/sources/local/user_local_data_source.dart';
import 'package:your_chef/features/user/data/sources/remote/user_remote_data_source.dart';
import 'package:your_chef/features/user/domain/entities/saved_user.dart';
import 'package:your_chef/features/user/domain/entities/user.dart';
import 'package:your_chef/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends IUserRepository {
  final IUserRemoteDataSource remoteDataSource;
  final IUserLocalDataSource localDataSource;

  const UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Unit>> deleteSavedUser(SavedUser user) async {
    try {
      await localDataSource.deleteSavedUser(SavedUserModel.fromEntity(user));
      return const Right(unit);
    } catch (e) {
      return Left(EmptyCacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUser() async {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> getUser() async {
    try {
      final UserModel user = await remoteDataSource.getUser();

      return Right(user.toEntity());
    } on NetworkException {
      try {
        final UserModel user = await localDataSource.getUser();
        return Right(user.toEntity());
      } on AuthException catch (e) {
        return Left(
          AuthFailure(e.message),
        );
      } catch (e) {
        return const Left(
          NetworkFailure(AppStrings.checkYourInternetConnection),
        );
      }
    } on AuthException {
      try {
        final UserModel user = await localDataSource.getUser();
        return Right(user.toEntity());
      } on AuthException catch (e) {
        return Left(
          AuthFailure(e.message),
        );
      } catch (e) {
        return const Left(
          AuthFailure(AppStrings.sessionExpired),
        );
      }
    } on ServerException {
      try {
        final UserModel user = await localDataSource.getUser();
        return Right(user.toEntity());
      } on AuthException catch (e) {
        return Left(
          AuthFailure(e.message),
        );
      } catch (e) {
        return const Left(
          ServerFailure(AppStrings.somethingWentWrong),
        );
      }
    } catch (e) {
      try {
        final UserModel user = await localDataSource.getUser();
        return Right(user.toEntity());
      } on AuthException catch (e) {
        return Left(
          AuthFailure(e.message),
        );
      } catch (e) {
        return const Left(
          EmptyCacheFailure(AppStrings.somethingWentWrong),
        );
      }
    }
  }

  @override
  Future<Either<Failure, User>> switchUser(SavedUser user) async {
    // TODO: implement switchUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> updateUser(UserOptions options) async {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}

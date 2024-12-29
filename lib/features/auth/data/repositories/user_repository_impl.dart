import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/errors/exceptions.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/auth/data/models/saved_user_model.dart';
import 'package:your_chef/features/auth/data/models/user_model.dart';
import 'package:your_chef/features/auth/data/sources/local/user_local_data_source.dart';
import 'package:your_chef/features/auth/data/sources/remote/user_remote_data_source.dart';
import 'package:your_chef/features/auth/domain/entities/saved_user.dart';
import 'package:your_chef/features/auth/domain/entities/user.dart';
import 'package:your_chef/features/auth/domain/repositories/user_repository.dart';

class UserRepository extends IUserRepository {
  final IUserRemoteDataSource remoteDataSource;
  final IUserLocalDataSource localDataSource;

  const UserRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Unit>> deleteSavedUser(SavedUser savedUser) async {
    try {
      await localDataSource
          .deleteSavedUser(SavedUserModel.fromEntity(savedUser));
      return const Right(unit);
    } catch (e) {
      log(e.toString());
      return Left(EmptyCacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUser() async {
    try {
      await remoteDataSource.deleteUser();
      return const Right(unit);
    } on NetworkException catch (e) {
      return Left(
        NetworkFailure(e.message),
      );
    } on AuthException catch (e) {
      return Left(
        AuthFailure(e.message),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(e.message),
      );
    } catch (e) {
      return Left(EmptyCacheFailure(e.toString()));
    }
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
  Future<Either<Failure, User>> switchUser(SavedUser savedUser) async {
    try {
      final UserModel user = await remoteDataSource
          .switchUser(SavedUserModel.fromEntity(savedUser));
      return Right(user.toEntity());
    } on NetworkException catch (e) {
      return Left(
        NetworkFailure(e.message),
      );
    } on AuthException catch (e) {
      return Left(
        AuthFailure(e.message),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(e.message),
      );
    } catch (e) {
      log(e.toString());
      return const Left(
        EmptyCacheFailure(AppStrings.somethingWentWrong),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUser(UserOptions options) async {
    try {
      await remoteDataSource.updateUser(options);
      return const Right(unit);
    } on NetworkException catch (e) {
      return Left(
        NetworkFailure(e.message),
      );
    } on AuthException catch (e) {
      return Left(
        AuthFailure(e.message),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(e.message),
      );
    } catch (e) {
      return const Left(
        ServerFailure(AppStrings.somethingWentWrong),
      );
    }
  }

  @override
  Future<Either<Failure, List<SavedUser>>> getSavedUsers() async {
    try {
      final List<SavedUserModel> savedUsers =
          await localDataSource.getSavedUsers();
      return Right(savedUsers.map((e) => e.toEntity()).toList());
    } catch (e) {
      return const Left(EmptyCacheFailure(AppStrings.somethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveUser(SavedUser savedUser) async {
    try {
      await localDataSource.saveUser(SavedUserModel.fromEntity(savedUser));
      return const Right(unit);
    } catch (e) {
      return const Left(EmptyCacheFailure(AppStrings.somethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.signOut();
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure(AppStrings.somethingWentWrong));
    }
  }
}

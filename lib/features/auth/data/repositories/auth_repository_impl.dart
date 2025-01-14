import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/errors/exceptions.dart';

import 'package:your_chef/core/errors/failures.dart';

import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/auth/data/models/saved_user_model.dart';
import 'package:your_chef/features/auth/domain/entities/saved_user.dart';

import '../../domain/repositories/auth_repository.dart';
import '../sources/remote/auth_remote_data_source.dart';

class AuthRepository implements IAuthRepository {
  const AuthRepository(this.remoteDataSource);

  final IAuthRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, SavedUser>> googleSignIn() async {
    try {
      final SavedUserModel user = await remoteDataSource.googleSignIn();
      return Right(user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      log(e.toString());
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SavedUser>> login(LoginOptions options) async {
    try {
      final SavedUserModel user = await remoteDataSource.login(options);
      return Right(user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(AppStrings.somethingWentWrong.tr()));
    }
  }

  @override
  Future<Either<Failure, String>> register(RegisterOptions options) async {
    try {
      final String uid = await remoteDataSource.register(options);
      return Right(uid);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(AppStrings.somethingWentWrong.tr()));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword(
      ResetPasswordOptions options) async {
    try {
      await remoteDataSource.resetPassword(options);
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(AppStrings.somethingWentWrong.tr()));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendOtpCode(
      ResetPasswordOptions options) async {
    try {
      await remoteDataSource.sendOtpCode(options);
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(AppStrings.somethingWentWrong.tr()));
    }
  }

  @override
  Future<Either<Failure, Unit>> uploadProfilePhoto(
      UploadProfileOptions options) async {
    try {
      await remoteDataSource.uploadProfilePhoto(options);
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(AppStrings.somethingWentWrong.tr()));
    }
  }

  @override
  Future<Either<Failure, Unit>> verify(VerifyOtpOptions options) async {
    try {
      await remoteDataSource.verify(options);
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(AppStrings.somethingWentWrong.tr()));
    }
  }
}

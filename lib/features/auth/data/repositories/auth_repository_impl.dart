import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/exceptions.dart';

import 'package:your_chef/core/errors/failures.dart';

import 'package:your_chef/core/options/options.dart';

import 'package:your_chef/features/auth/domain/entities/user.dart';

import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../sources/remote/auth_remote_data_source.dart';

class AuthRepository implements IAuthRepository {
  final IAuthRemoteDataSource remoteDataSource;

  const AuthRepository(this.remoteDataSource);
  @override
  Future<Either<Failure, User>> login(LoginOptions options) async {
    try {
      final UserModel user = await remoteDataSource.login(options);
      return Right(user.toEntity());
    } on AuthException {
      return const Left(AuthFailure('Invalid credentials'));
    } on NetworkException {
      return const Left(NetworkFailure('Check your internet connection'));
    } on ServerException {
      return const Left(ServerFailure('Something went wrong'));
    } catch (e) {
      return const Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, Unit>> register(RegisterOptions options) async {
    try {
      await remoteDataSource.register(options);
      return const Right(unit);
    } on AuthException {
      return const Left(AuthFailure('Invalid credentials'));
    } on NetworkException {
      return const Left(NetworkFailure('Check your internet connection'));
    } on ServerException {
      return const Left(ServerFailure('Something went wrong'));
    } catch (e) {
      return const Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword(
      ResetPasswordOptions options) async {
    try {
      await remoteDataSource.resetPassword(options);
      return const Right(unit);
    } on AuthException {
      return const Left(AuthFailure('Invalid credentials'));
    } on NetworkException {
      return const Left(NetworkFailure('Check your internet connection'));
    } on ServerException {
      return const Left(ServerFailure('Something went wrong'));
    } catch (e) {
      return const Left(ServerFailure('Something went wrong'));
    }
  }
}

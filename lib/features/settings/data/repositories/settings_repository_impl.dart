import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/exceptions.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/utils/user_helper.dart';
import 'package:your_chef/features/settings/data/sources/remote/settings_remote_data_source.dart';
import 'package:your_chef/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepository extends ISettingsRepository {
  final ISettingsRemoteDataSource remoteDataSource;

  const SettingsRepository(this.remoteDataSource);
  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(unit);
    } on NetworkException {
      return const Left(NetworkFailure('Check your internet connection'));
    } on ServerException {
      return const Left(ServerFailure('Something went wrong'));
    } catch (e) {
      return const Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, Unit>> switchAccount(SavedUser savedUser) async {
    try {
      await remoteDataSource.switchAccount(savedUser);
      return const Right(unit);
    } on NetworkException {
      return const Left(NetworkFailure('Check your internet connection'));
    } on AuthException {
      return const Left(AuthFailure('Invalid credentials'));
    } on ServerException {
      return const Left(ServerFailure('Something went wrong'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

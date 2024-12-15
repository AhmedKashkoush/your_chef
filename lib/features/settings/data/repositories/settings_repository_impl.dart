import 'package:dartz/dartz.dart';
import 'package:your_chef/core/constants/strings.dart';
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

  @override
  Future<Either<Failure, Unit>> switchAccount(SavedUser savedUser) async {
    try {
      await remoteDataSource.switchAccount(savedUser);
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

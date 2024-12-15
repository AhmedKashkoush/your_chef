import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/utils/user_helper.dart';

abstract class ISettingsRepository {
  const ISettingsRepository();

  Future<Either<Failure, Unit>> signOut();
  Future<Either<Failure, Unit>> switchAccount(SavedUser savedUser);
}

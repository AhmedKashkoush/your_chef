import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';

abstract class ISettingsRepository {
  const ISettingsRepository();

  Future<Either<Failure, Unit>> signOut();
}

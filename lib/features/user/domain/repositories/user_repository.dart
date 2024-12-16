import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/user/domain/entities/saved_user.dart';

import 'package:your_chef/features/user/domain/entities/user.dart';

abstract class IUserRepository {
  const IUserRepository();
  Future<Either<Failure, User>> getUser();
  Future<Either<Failure, Unit>> updateUser(UserOptions options);
  Future<Either<Failure, Unit>> deleteUser();
  Future<Either<Failure, Unit>> deleteSavedUser(SavedUser user);
  Future<Either<Failure, User>> switchUser(SavedUser user);
}

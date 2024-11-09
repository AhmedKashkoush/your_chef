import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/auth/domain/entities/user.dart';

abstract class IAuthRepository {
  Future<Either<Failure, User>> login(LoginOptions options);
  Future<Either<Failure, Unit>> register(RegisterOptions options);
  Future<Either<Failure, Unit>> resetPassword(ResetPasswordOptions options);
}

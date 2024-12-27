import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/auth/domain/entities/saved_user.dart';

abstract class IAuthRepository {
  Future<Either<Failure, SavedUser>> login(LoginOptions options);
  Future<Either<Failure, SavedUser>> googleSignIn();
  Future<Either<Failure, Unit>> sendOtpCode(ResetPasswordOptions options);
  Future<Either<Failure, Unit>> verify(VerifyOtpOptions options);
  Future<Either<Failure, String>> register(RegisterOptions options);
  Future<Either<Failure, Unit>> resetPassword(ResetPasswordOptions options);
  Future<Either<Failure, Unit>> uploadProfilePhoto(
    UploadProfileOptions options,
  );
}

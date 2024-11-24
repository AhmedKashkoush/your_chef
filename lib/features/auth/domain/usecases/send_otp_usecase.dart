import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/auth/domain/repositories/auth_repository.dart';

class SendOtpUseCase extends UseCase<Unit, ResetPasswordOptions> {
  final IAuthRepository repository;
  const SendOtpUseCase(this.repository);
  @override
  Future<Either<Failure, Unit>> call(ResetPasswordOptions params) {
    return repository.sendOtpCode(params);
  }
}

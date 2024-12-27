import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/auth/domain/repositories/auth_repository.dart';

import '../../../../../core/options/options.dart';

class VerifyOtpUseCase extends UseCase<Unit, VerifyOtpOptions> {
  final IAuthRepository repository;
  const VerifyOtpUseCase(this.repository);
  @override
  Future<Either<Failure, Unit>> call(VerifyOtpOptions params) {
    return repository.verify(params);
  }
}

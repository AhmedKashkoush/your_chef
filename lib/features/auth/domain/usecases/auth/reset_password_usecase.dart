import 'package:dartz/dartz.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/usecases/usecases.dart';

import '../../../../../core/errors/failures.dart';
import '../../repositories/auth_repository.dart';

class ResetPasswordUseCase extends UseCase<Unit, ResetPasswordOptions> {
  final IAuthRepository repository;
  const ResetPasswordUseCase(this.repository);
  @override
  Future<Either<Failure, Unit>> call(ResetPasswordOptions params) {
    return repository.resetPassword(params);
  }
}

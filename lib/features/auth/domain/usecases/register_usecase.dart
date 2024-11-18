import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/options/options.dart';
import '../../../../core/usecases/usecases.dart';

class RegisterUseCase extends UseCase<String, RegisterOptions> {
  final IAuthRepository repository;
  const RegisterUseCase(this.repository);
  @override
  Future<Either<Failure, String>> call(RegisterOptions params) {
    return repository.register(params);
  }
}

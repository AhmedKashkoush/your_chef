import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/auth/domain/entities/user.dart';

import '../repositories/auth_repository.dart';

class GoogleSignUseCase extends NoParamsUseCase<User> {
  final IAuthRepository repository;
  const GoogleSignUseCase(this.repository);
  @override
  Future<Either<Failure, User>> call() {
    return repository.googleSignIn();
  }
}

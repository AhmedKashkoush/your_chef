import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/auth/domain/repositories/user_repository.dart';

class SignOutUseCase extends NoParamsUseCase<Unit> {
  final IUserRepository repository;

  const SignOutUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call() {
    return repository.signOut();
  }
}

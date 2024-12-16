import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/user/domain/repositories/user_repository.dart';

class DeleteUserUseCase extends NoParamsUseCase<Unit> {
  final IUserRepository repository;

  const DeleteUserUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call() {
    return repository.deleteUser();
  }
}

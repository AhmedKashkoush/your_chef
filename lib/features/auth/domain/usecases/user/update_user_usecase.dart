import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/auth/domain/repositories/user_repository.dart';

class UpdateUserUseCase extends UseCase<Unit, UserOptions> {
  final IUserRepository repository;

  const UpdateUserUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UserOptions params) {
    return repository.updateUser(params);
  }
}

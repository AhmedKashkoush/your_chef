import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/user/domain/entities/saved_user.dart';
import 'package:your_chef/features/user/domain/entities/user.dart';
import 'package:your_chef/features/user/domain/repositories/user_repository.dart';

class SwitchUserUseCase extends UseCase<User, SavedUser> {
  final IUserRepository repository;

  const SwitchUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(SavedUser params) {
    return repository.switchUser(params);
  }
}

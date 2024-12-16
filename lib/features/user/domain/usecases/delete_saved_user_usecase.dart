import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/user/domain/entities/saved_user.dart';

import 'package:your_chef/features/user/domain/repositories/user_repository.dart';

class DeleteSavedUserUseCase extends UseCase<Unit, SavedUser> {
  final IUserRepository repository;

  const DeleteSavedUserUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SavedUser params) {
    return repository.deleteSavedUser(params);
  }
}

import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/user/domain/entities/saved_user.dart';
import 'package:your_chef/features/user/domain/repositories/user_repository.dart';

class GetSavedUsersUseCase extends NoParamsUseCase<List<SavedUser>> {
  final IUserRepository repository;

  const GetSavedUsersUseCase(this.repository);

  @override
  Future<Either<Failure, List<SavedUser>>> call() {
    return repository.getSavedUsers();
  }
}

import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/user/domain/entities/user.dart';
import 'package:your_chef/features/user/domain/repositories/user_repository.dart';

class GetUserUseCase extends NoParamsUseCase<User> {
  final IUserRepository repository;

  const GetUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call() {
    return repository.getUser();
  }
}

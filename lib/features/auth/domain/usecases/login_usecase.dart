import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/user/domain/entities/user.dart';
import 'package:your_chef/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase extends UseCase<User, LoginOptions> {
  final IAuthRepository repository;
  const LoginUseCase(this.repository);
  @override
  Future<Either<Failure, User>> call(LoginOptions params) {
    return repository.login(params);
  }
}

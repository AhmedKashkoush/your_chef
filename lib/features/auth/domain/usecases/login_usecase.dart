import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/user/domain/entities/saved_user.dart';
import 'package:your_chef/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase extends UseCase<SavedUser, LoginOptions> {
  final IAuthRepository repository;
  const LoginUseCase(this.repository);
  @override
  Future<Either<Failure, SavedUser>> call(LoginOptions params) {
    return repository.login(params);
  }
}

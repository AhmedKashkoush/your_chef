import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/settings/domain/repositories/settings_repository.dart';

class SignOutUseCase extends NoParamsUseCase<Unit> {
  final ISettingsRepository repository;

  const SignOutUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call() {
    return repository.signOut();
  }
}

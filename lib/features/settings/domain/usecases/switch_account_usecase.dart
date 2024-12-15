import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/core/utils/user_helper.dart';
import 'package:your_chef/features/settings/domain/repositories/settings_repository.dart';

class SwitchAccountUseCase extends UseCase<Unit, SavedUser> {
  final ISettingsRepository repository;

  const SwitchAccountUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SavedUser params) {
    return repository.switchAccount(params);
  }
}

import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/auth/domain/repositories/auth_repository.dart';

class UploadProfilePhotoUseCase extends UseCase<Unit, UploadProfileOptions> {
  final IAuthRepository repository;
  const UploadProfilePhotoUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UploadProfileOptions params) {
    return repository.uploadProfilePhoto(params);
  }
}

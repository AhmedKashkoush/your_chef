import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/foods/domain/repositories/cart_repository.dart';

class GetCartTotalUseCase extends NoParamsUseCase<num> {
  final ICartRepository repository;
  const GetCartTotalUseCase(this.repository);
  @override
  Future<Either<Failure, num>> call() {
    return repository.getTotal();
  }
}

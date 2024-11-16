import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';
import 'package:your_chef/features/home/domain/repositories/home_repository.dart';

class GetOnSaleProductsUseCase extends NoParamsUseCase<List<Product>> {
  final IHomeRepository repository;

  const GetOnSaleProductsUseCase(this.repository);
  @override
  Future<Either<Failure, List<Product>>> call() {
    return repository.getOnSaleProducts();
  }
}

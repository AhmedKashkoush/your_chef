import 'package:dartz/dartz.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/usecases/usecases.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/wishlist/domain/repositories/wishlist_repository.dart';

class GetFoodsWishlistUseCase extends UseCase<List<Food>, PaginationOptions> {
  final IWishlistRepository repository;
  const GetFoodsWishlistUseCase(this.repository);
  @override
  Future<Either<Failure, List<Food>>> call(PaginationOptions params) {
    return repository.getFoodsWishList(params);
  }
}

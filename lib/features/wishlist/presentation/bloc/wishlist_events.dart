part of 'wishlist_bloc.dart';

sealed class WishlistEvent extends Equatable {
  const WishlistEvent();
}

class GetFoodsWishlistEvent extends WishlistEvent {
  final PaginationOptions options;
  const GetFoodsWishlistEvent(this.options);

  @override
  List<Object?> get props => [options];
}

class RefreshFoodsWishlistEvent extends WishlistEvent {
  final PaginationOptions options;
  const RefreshFoodsWishlistEvent(this.options);

  @override
  List<Object?> get props => [options];
}

class AddFoodToWishlistWishlistEvent extends WishlistEvent {
  final Product food;
  const AddFoodToWishlistWishlistEvent(this.food);

  @override
  List<Object?> get props => [food];
}

class RemoveFoodFromWishlistWishlistEvent extends WishlistEvent {
  final Product food;
  const RemoveFoodFromWishlistWishlistEvent(this.food);

  @override
  List<Object?> get props => [food];
}

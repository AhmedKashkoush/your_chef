part of 'add_remove_cart_bloc.dart';

sealed class AddRemoveCartEvent extends Equatable {
  const AddRemoveCartEvent();

  @override
  List<Object> get props => [];
}

final class AddToCartEvent extends AddRemoveCartEvent {
  final Food food;

  const AddToCartEvent(this.food);

  @override
  List<Object> get props => [food];
}

final class RemoveFromCartEvent extends AddRemoveCartEvent {
  final Food food;

  const RemoveFromCartEvent(this.food);

  @override
  List<Object> get props => [food];
}

part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

final class GetCartEvent extends CartEvent {
  @override
  List<Object> get props => [];
}

final class EmptyCartEvent extends CartEvent {
  @override
  List<Object> get props => [];
}

final class GetCartTotalEvent extends CartEvent {
  @override
  List<Object> get props => [];
}

final class GetCartFeesEvent extends CartEvent {
  @override
  List<Object> get props => [];
}

final class AddFoodToCartEvent extends CartEvent {
  final Food food;

  const AddFoodToCartEvent(this.food);

  @override
  List<Object> get props => [food];
}

final class RemoveFoodFromCartEvent extends CartEvent {
  final Food food;

  const RemoveFoodFromCartEvent(this.food);

  @override
  List<Object> get props => [food];
}

final class IncrementCartItemEvent extends CartEvent {
  final CartItem item;

  const IncrementCartItemEvent(this.item);

  @override
  List<Object> get props => [item];
}

final class DecrementCartItemEvent extends CartEvent {
  final CartItem item;

  const DecrementCartItemEvent(this.item);

  @override
  List<Object> get props => [item];
}

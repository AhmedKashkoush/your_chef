part of 'cart_quantity_bloc.dart';

sealed class CartQuantityEvent extends Equatable {
  const CartQuantityEvent();

  @override
  List<Object> get props => [];
}

final class IncrementCartQuantityEvent extends CartQuantityEvent {
  final CartItem item;

  const IncrementCartQuantityEvent(this.item);

  @override
  List<Object> get props => [item];
}

final class DecrementCartQuantityEvent extends CartQuantityEvent {
  final CartItem item;

  const DecrementCartQuantityEvent(this.item);

  @override
  List<Object> get props => [item];
}

part of 'cart_quantity_bloc.dart';

sealed class CartQuantityState extends Equatable {
  const CartQuantityState();

  @override
  List<Object> get props => [];
}

final class CartQuantityInitialState extends CartQuantityState {
  const CartQuantityInitialState();
  @override
  List<Object> get props => [];
}

final class CartQuantityLoadingState extends CartQuantityState {
  const CartQuantityLoadingState();
  @override
  List<Object> get props => [];
}

final class CartQuantitySuccessState extends CartQuantityState {
  final String message;

  const CartQuantitySuccessState(this.message);

  @override
  List<Object> get props => [message];
}

final class CartQuantityFailureState extends CartQuantityState {
  final String error;
  final ErrorType errorType;

  const CartQuantityFailureState(this.error,
      {this.errorType = ErrorType.normal});

  @override
  List<Object> get props => [error, errorType];
}

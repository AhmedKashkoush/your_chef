part of 'add_remove_cart_bloc.dart';

sealed class AddRemoveCartState extends Equatable {
  const AddRemoveCartState();

  @override
  List<Object> get props => [];
}

final class AddRemoveCartInitialState extends AddRemoveCartState {
  const AddRemoveCartInitialState();
}

final class AddToCartLoadingState extends AddRemoveCartState {
  const AddToCartLoadingState();
}

final class AddToCartSuccessState extends AddRemoveCartState {
  final String message;
  const AddToCartSuccessState(this.message);

  @override
  List<Object> get props => [message];
}

final class AddToCartFailureState extends AddRemoveCartState {
  final String error;
  final ErrorType errorType;
  const AddToCartFailureState(this.error, {this.errorType = ErrorType.normal});

  @override
  List<Object> get props => [error, errorType];
}

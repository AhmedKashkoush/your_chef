part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final num total, fees;
  final RequestStatus status;
  final String error, message;
  final ErrorType errorType;
  const CartState({
    this.items = const [],
    this.total = 0,
    this.fees = 0,
    this.status = RequestStatus.initial,
    this.error = '',
    this.message = '',
    this.errorType = ErrorType.normal,
  });

  CartState copyWith({
    List<CartItem>? items,
    num? total,
    num? fees,
    RequestStatus? status,
    String? error,
    String? message,
    ErrorType? errorType,
  }) {
    return CartState(
      items: items ?? this.items,
      total: total ?? this.total,
      fees: fees ?? this.fees,
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
      errorType: errorType ?? this.errorType,
    );
  }

  @override
  List<Object> get props => [
        items,
        total,
        fees,
        status,
        error,
        message,
        errorType,
      ];
}

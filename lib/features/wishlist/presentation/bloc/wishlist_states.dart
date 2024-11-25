part of 'wishlist_bloc.dart';

class WishlistState extends Equatable {
  final List<Product> foods;
  final bool foodsHasNext;
  final String error;
  final RequestStatus status;
  final ErrorType errorType;

  const WishlistState({
    this.foods = const [],
    this.foodsHasNext = true,
    this.error = '',
    this.status = RequestStatus.initial,
    this.errorType = ErrorType.normal,
  });

  WishlistState copyWith({
    List<Product>? foods,
    bool? foodsHasNext,
    String? error,
    RequestStatus? status,
    ErrorType? errorType,
  }) =>
      WishlistState(
        foods: foods ?? this.foods,
        foodsHasNext: foodsHasNext ?? this.foodsHasNext,
        error: error ?? this.error,
        status: status ?? this.status,
        errorType: errorType ?? this.errorType,
      );

  @override
  List<Object?> get props => [
        foods,
        error,
        status,
      ];
}

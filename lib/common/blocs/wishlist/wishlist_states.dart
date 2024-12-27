part of 'wishlist_bloc.dart';

class WishlistState extends Equatable {
  final List<Food> foods;
  final bool foodsHasNext, addOrRemove;
  final String error;
  final RequestStatus status;
  final ErrorType errorType;

  const WishlistState({
    this.foods = const [],
    this.foodsHasNext = true,
    this.error = '',
    this.status = RequestStatus.initial,
    this.errorType = ErrorType.normal,
    this.addOrRemove = false,
  });

  WishlistState copyWith({
    List<Food>? foods,
    bool? foodsHasNext,
    bool? addOrRemove,
    String? error,
    RequestStatus? status,
    ErrorType? errorType,
  }) =>
      WishlistState(
        foods: foods ?? this.foods,
        foodsHasNext: foodsHasNext ?? this.foodsHasNext,
        addOrRemove: addOrRemove ?? this.addOrRemove,
        error: error ?? this.error,
        status: status ?? this.status,
        errorType: errorType ?? this.errorType,
      );

  @override
  List<Object?> get props =>
      [foods, error, status, errorType, foodsHasNext, addOrRemove];
}

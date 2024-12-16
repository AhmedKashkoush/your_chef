part of 'restaurant_bloc.dart';

class RestaurantState extends Equatable {
  final List<Offer> offers;
  final List<Food> foods;
  final RequestStatus status;
  final String error;
  final ErrorType errorType;

  const RestaurantState({
    this.offers = const <Offer>[],
    this.foods = const <Food>[],
    this.status = RequestStatus.initial,
    this.error = '',
    this.errorType = ErrorType.normal,
  });

  RestaurantState copyWith({
    List<Offer>? offers,
    List<Food>? foods,
    RequestStatus? status,
    String? error,
    ErrorType? errorType,
  }) {
    return RestaurantState(
      offers: offers ?? this.offers,
      foods: foods ?? this.foods,
      status: status ?? this.status,
      error: error ?? this.error,
      errorType: errorType ?? this.errorType,
    );
  }

  @override
  List<Object> get props => [offers, foods, status, error, errorType];
}

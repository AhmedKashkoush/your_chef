part of 'get_restaurant_offers_bloc.dart';

sealed class GetRestaurantOffersState extends Equatable {
  const GetRestaurantOffersState();

  @override
  List<Object> get props => [];
}

class GetRestaurantOffersInitialState extends GetRestaurantOffersState {
  const GetRestaurantOffersInitialState();
}

class GetRestaurantOffersLoadingState extends GetRestaurantOffersState {
  const GetRestaurantOffersLoadingState();
}

class GetRestaurantOffersSuccessState extends GetRestaurantOffersState {
  final List<Offer> offers;
  const GetRestaurantOffersSuccessState(this.offers);

  @override
  List<Object> get props => [offers];
}

class GetRestaurantOffersErrorState extends GetRestaurantOffersState {
  final String error;
  final ErrorType errorType;
  const GetRestaurantOffersErrorState(this.error,
      {this.errorType = ErrorType.normal});

  @override
  List<Object> get props => [error, errorType];
}

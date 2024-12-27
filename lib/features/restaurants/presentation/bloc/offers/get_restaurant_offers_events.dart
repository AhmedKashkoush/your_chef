part of 'get_restaurant_offers_bloc.dart';

sealed class GetRestaurantOffersEvent extends Equatable {
  const GetRestaurantOffersEvent();

  @override
  List<Object> get props => [];
}

class GetRestaurantOffersEventStarted extends GetRestaurantOffersEvent {
  final RestaurantOptions options;
  const GetRestaurantOffersEventStarted(this.options);

  @override
  List<Object> get props => [options];
}

part of 'get_restaurant_menu_bloc.dart';

sealed class GetRestaurantMenuEvent extends Equatable {
  const GetRestaurantMenuEvent();
}

class GetRestaurantMenuEventStarted extends GetRestaurantMenuEvent {
  final RestaurantOptions options;

  const GetRestaurantMenuEventStarted(this.options);

  @override
  List<Object?> get props => [options];
}

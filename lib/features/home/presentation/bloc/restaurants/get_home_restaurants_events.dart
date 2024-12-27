part of 'get_home_restaurants_bloc.dart';

sealed class GetHomeRestaurantsEvent extends Equatable {
  const GetHomeRestaurantsEvent();

  @override
  List<Object> get props => [];
}

class GetHomeRestaurantsEventStarted extends GetHomeRestaurantsEvent {
  const GetHomeRestaurantsEventStarted();
}

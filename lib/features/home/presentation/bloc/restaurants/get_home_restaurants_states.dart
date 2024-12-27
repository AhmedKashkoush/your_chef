part of 'get_home_restaurants_bloc.dart';

sealed class GetHomeRestaurantsState extends Equatable {
  const GetHomeRestaurantsState();

  @override
  List<Object> get props => [];
}

class GetHomeRestaurantsInitialState extends GetHomeRestaurantsState {
  const GetHomeRestaurantsInitialState();
}

class GetHomeRestaurantsLoadingState extends GetHomeRestaurantsState {
  const GetHomeRestaurantsLoadingState();
}

class GetHomeRestaurantsSuccessState extends GetHomeRestaurantsState {
  final List<Restaurant> restaurants;
  const GetHomeRestaurantsSuccessState(this.restaurants);

  @override
  List<Object> get props => [restaurants];
}

class GetHomeRestaurantsErrorState extends GetHomeRestaurantsState {
  final String error;
  final ErrorType errorType;
  const GetHomeRestaurantsErrorState(this.error, {required this.errorType});

  @override
  List<Object> get props => [error, errorType];
}

part of 'get_restaurant_menu_bloc.dart';

sealed class GetRestaurantMenuState extends Equatable {
  const GetRestaurantMenuState();

  @override
  List<Object?> get props => [];
}

class GetRestaurantMenuInitialState extends GetRestaurantMenuState {
  const GetRestaurantMenuInitialState();
}

class GetRestaurantMenuLoadingState extends GetRestaurantMenuState {
  const GetRestaurantMenuLoadingState();
}

class GetRestaurantMenuSuccessState extends GetRestaurantMenuState {
  final List<Food> foods;
  const GetRestaurantMenuSuccessState(this.foods);

  @override
  List<Object?> get props => [foods];
}

class GetRestaurantMenuErrorState extends GetRestaurantMenuState {
  final String error;
  final ErrorType errorType;
  const GetRestaurantMenuErrorState(this.error,
      {this.errorType = ErrorType.normal});

  @override
  List<Object?> get props => [error, errorType];
}

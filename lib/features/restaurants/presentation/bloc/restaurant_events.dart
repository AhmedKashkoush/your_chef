part of 'restaurant_bloc.dart';

abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();
}

class GetDataEvent extends RestaurantEvent {
  final RestaurantOptions options;

  const GetDataEvent({required this.options});

  @override
  List<Object> get props => [options];
}

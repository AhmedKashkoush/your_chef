part of 'get_home_on_sale_foods_bloc.dart';

sealed class GetHomeOnSaleFoodsState extends Equatable {
  const GetHomeOnSaleFoodsState();

  @override
  List<Object> get props => [];
}

class GetHomeOnSaleFoodsInitialState extends GetHomeOnSaleFoodsState {
  const GetHomeOnSaleFoodsInitialState();
}

class GetHomeOnSaleFoodsLoadingState extends GetHomeOnSaleFoodsState {
  const GetHomeOnSaleFoodsLoadingState();
}

class GetHomeOnSaleFoodsSuccessState extends GetHomeOnSaleFoodsState {
  final List<Food> foods;

  const GetHomeOnSaleFoodsSuccessState(this.foods);

  @override
  List<Object> get props => [foods];
}

class GetHomeOnSaleFoodsErrorState extends GetHomeOnSaleFoodsState {
  final String error;
  final ErrorType errorType;

  const GetHomeOnSaleFoodsErrorState(this.error, {required this.errorType});

  @override
  List<Object> get props => [error, errorType];
}

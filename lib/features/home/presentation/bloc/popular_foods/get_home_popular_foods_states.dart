part of 'get_home_popular_foods_bloc.dart';

sealed class GetHomePopularFoodsState extends Equatable {
  const GetHomePopularFoodsState();

  @override
  List<Object> get props => [];
}

class GetHomePopularFoodsInitialState extends GetHomePopularFoodsState {
  const GetHomePopularFoodsInitialState();
}

class GetHomePopularFoodsLoadingState extends GetHomePopularFoodsState {
  const GetHomePopularFoodsLoadingState();
}

class GetHomePopularFoodsSuccessState extends GetHomePopularFoodsState {
  final List<Food> foods;

  const GetHomePopularFoodsSuccessState(this.foods);

  @override
  List<Object> get props => [foods];
}

class GetHomePopularFoodsErrorState extends GetHomePopularFoodsState {
  final String error;
  final ErrorType errorType;

  const GetHomePopularFoodsErrorState(this.error, {required this.errorType});

  @override
  List<Object> get props => [error, errorType];
}

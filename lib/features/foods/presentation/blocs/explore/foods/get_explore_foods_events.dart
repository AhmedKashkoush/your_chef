part of 'get_explore_foods_bloc.dart';

sealed class GetExploreFoodsEvent extends Equatable {
  const GetExploreFoodsEvent();

  @override
  List<Object> get props => [];
}

class GetExploreRefreshFoodsEvent extends GetExploreFoodsEvent {
  const GetExploreRefreshFoodsEvent();
}

class GetExplorePopularFoodsEvent extends GetExploreFoodsEvent {
  final PaginationOptions options;
  const GetExplorePopularFoodsEvent(this.options);

  @override
  List<Object> get props => [options];
}

class GetExploreOnASaleFoodsEvent extends GetExploreFoodsEvent {
  final PaginationOptions options;
  const GetExploreOnASaleFoodsEvent(this.options);

  @override
  List<Object> get props => [options];
}

class GetExploreFoodsByCategoryEvent extends GetExploreFoodsEvent {
  final PaginationOptions<Category> options;
  const GetExploreFoodsByCategoryEvent(this.options);

  @override
  List<Object> get props => [options];
}

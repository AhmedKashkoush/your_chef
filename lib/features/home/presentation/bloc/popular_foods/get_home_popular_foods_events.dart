part of 'get_home_popular_foods_bloc.dart';

sealed class GetHomePopularFoodsEvent extends Equatable {
  const GetHomePopularFoodsEvent();

  @override
  List<Object?> get props => [];
}

class GetHomePopularFoodsEventStarted extends GetHomePopularFoodsEvent {
  final PaginationOptions options;
  const GetHomePopularFoodsEventStarted(this.options);
}

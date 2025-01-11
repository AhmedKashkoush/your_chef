part of 'get_explore_categories_bloc.dart';

sealed class GetExploreCategoriesEvent extends Equatable {
  const GetExploreCategoriesEvent();

  @override
  List<Object> get props => [];
}

class GetExploreCategoriesEventStarted extends GetExploreCategoriesEvent {
  const GetExploreCategoriesEventStarted();
}

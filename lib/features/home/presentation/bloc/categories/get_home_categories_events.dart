part of 'get_home_categories_bloc.dart';

sealed class GetHomeCategoriesEvent extends Equatable {
  const GetHomeCategoriesEvent();

  @override
  List<Object> get props => [];
}

class GetHomeCategoriesEventStarted extends GetHomeCategoriesEvent {
  final GetCategoriesOptions options;

  const GetHomeCategoriesEventStarted(this.options);

  @override
  List<Object> get props => [options];
}

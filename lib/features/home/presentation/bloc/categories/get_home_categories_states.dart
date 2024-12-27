part of 'get_home_categories_bloc.dart';

sealed class GetHomeCategoriesState extends Equatable {
  const GetHomeCategoriesState();

  @override
  List<Object> get props => [];
}

class GetHomeCategoriesInitialState extends GetHomeCategoriesState {
  const GetHomeCategoriesInitialState();
}

class GetHomeCategoriesLoadingState extends GetHomeCategoriesState {
  const GetHomeCategoriesLoadingState();
}

class GetHomeCategoriesSuccessState extends GetHomeCategoriesState {
  final List<Category> categories;
  const GetHomeCategoriesSuccessState(this.categories);

  @override
  List<Object> get props => [categories];
}

class GetHomeCategoriesErrorState extends GetHomeCategoriesState {
  final String error;
  final ErrorType errorType;
  const GetHomeCategoriesErrorState(
    this.error, {
    this.errorType = ErrorType.normal,
  });

  @override
  List<Object> get props => [error, errorType];
}

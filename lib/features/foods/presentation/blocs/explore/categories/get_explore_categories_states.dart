part of 'get_explore_categories_bloc.dart';

sealed class GetExploreCategoriesState extends Equatable {
  const GetExploreCategoriesState();

  @override
  List<Object> get props => [];
}

class GetExploreCategoriesInitialState extends GetExploreCategoriesState {
  const GetExploreCategoriesInitialState();
}

class GetExploreCategoriesLoadingState extends GetExploreCategoriesState {
  const GetExploreCategoriesLoadingState();
}

class GetExploreCategoriesSuccessState extends GetExploreCategoriesState {
  final List<Category> categories;

  const GetExploreCategoriesSuccessState(this.categories);

  @override
  List<Object> get props => [categories];
}

class GetExploreCategoriesErrorState extends GetExploreCategoriesState {
  final String error;
  final ErrorType errorType;

  const GetExploreCategoriesErrorState(this.error,
      {this.errorType = ErrorType.normal});

  @override
  List<Object> get props => [error, errorType];
}

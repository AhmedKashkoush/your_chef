part of 'get_all_categories_bloc.dart';

sealed class GetAllCategoriesState extends Equatable {
  const GetAllCategoriesState();

  @override
  List<Object> get props => [];
}

class GetAllCategoriesInitialState extends GetAllCategoriesState {
  const GetAllCategoriesInitialState();
}

class GetAllCategoriesLoadingState extends GetAllCategoriesState {
  const GetAllCategoriesLoadingState();
}

class GetAllCategoriesSuccessState extends GetAllCategoriesState {
  final List<Category> categories;

  const GetAllCategoriesSuccessState(this.categories);

  @override
  List<Object> get props => [categories];
}

class GetAllCategoriesErrorState extends GetAllCategoriesState {
  final String error;
  final ErrorType errorType;

  const GetAllCategoriesErrorState(this.error,
      {this.errorType = ErrorType.normal});

  @override
  List<Object> get props => [error, errorType];
}

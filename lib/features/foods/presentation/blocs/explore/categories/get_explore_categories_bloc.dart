import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/features/categories/domain/entities/category.dart';
import 'package:your_chef/features/categories/domain/usecases/get_all_categories_usecase.dart';

part 'get_explore_categories_events.dart';
part 'get_explore_categories_states.dart';

class GetExploreCategoriesBloc
    extends Bloc<GetExploreCategoriesEvent, GetExploreCategoriesState> {
  final GetAllCategoriesUseCase getAllCategoriesUseCase;
  GetExploreCategoriesBloc(this.getAllCategoriesUseCase)
      : super(const GetExploreCategoriesInitialState()) {
    on<GetExploreCategoriesEventStarted>(_getAllCategories,
        transformer: droppable());
  }

  FutureOr<void> _getAllCategories(GetExploreCategoriesEventStarted event,
      Emitter<GetExploreCategoriesState> emit) async {
    emit(const GetExploreCategoriesLoadingState());
    final Either<Failure, List<Category>> result =
        await getAllCategoriesUseCase.call();
    result.fold(
        (failure) => GetExploreCategoriesErrorState(
              failure.message,
              errorType: switch (failure.runtimeType) {
                const (NetworkFailure) => ErrorType.network,
                const (AuthFailure) => ErrorType.auth,
                const (ServerFailure) => ErrorType.normal,
                _ => ErrorType.normal,
              },
            ), (categories) {
      emit(GetExploreCategoriesSuccessState([
        const Category(id: 0, name: AppStrings.popularFoods, image: ''),
        const Category(id: 0, name: AppStrings.onASale, image: ''),
        ...categories
      ]));
    });
  }
}

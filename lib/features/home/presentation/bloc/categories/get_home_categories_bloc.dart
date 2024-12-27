import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/categories/domain/entities/category.dart';
import 'package:your_chef/features/categories/domain/usecases/get_categories_usecase.dart';

part 'get_home_categories_events.dart';
part 'get_home_categories_states.dart';

class GetHomeCategoriesBloc
    extends Bloc<GetHomeCategoriesEvent, GetHomeCategoriesState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  GetHomeCategoriesBloc(this.getCategoriesUseCase)
      : super(
          const GetHomeCategoriesInitialState(),
        ) {
    on<GetHomeCategoriesEventStarted>(_getCategories);
  }

  FutureOr<void> _getCategories(GetHomeCategoriesEventStarted event,
      Emitter<GetHomeCategoriesState> emit) async {
    emit(const GetHomeCategoriesLoadingState());
    final Either<Failure, List<Category>> result =
        await getCategoriesUseCase(const GetCategoriesOptions());
    result.fold((failure) {
      if (failure is NetworkFailure) {
        emit(
          GetHomeCategoriesErrorState(
            failure.message,
            errorType: ErrorType.network,
          ),
        );
      }
      if (failure is ServerFailure) {
        emit(
          GetHomeCategoriesErrorState(
            failure.message,
            errorType: ErrorType.normal,
          ),
        );
      }
    }, (categories) {
      emit(GetHomeCategoriesSuccessState(categories));
    });
  }
}

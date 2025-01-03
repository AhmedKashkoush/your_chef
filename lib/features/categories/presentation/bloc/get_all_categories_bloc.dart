import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/features/categories/domain/entities/category.dart';
import 'package:your_chef/features/categories/domain/usecases/get_all_categories_usecase.dart';

part 'get_all_categories_events.dart';
part 'get_all_categories_states.dart';

class GetAllCategoriesBloc
    extends Bloc<GetAllCategoriesEvent, GetAllCategoriesState> {
  final GetAllCategoriesUseCase getAllCategoriesUseCase;
  GetAllCategoriesBloc(this.getAllCategoriesUseCase)
      : super(const GetAllCategoriesInitialState()) {
    on<GetAllCategoriesEventStarted>(_getAllCategories,
        transformer: droppable());
  }

  FutureOr<void> _getAllCategories(GetAllCategoriesEventStarted event,
      Emitter<GetAllCategoriesState> emit) async {
    emit(const GetAllCategoriesLoadingState());
    final Either<Failure, List<Category>> result =
        await getAllCategoriesUseCase.call();
    result.fold((failure) {
      if (failure is NetworkFailure) {
        emit(
          GetAllCategoriesErrorState(
            failure.message,
            errorType: ErrorType.network,
          ),
        );
      }
      if (failure is ServerFailure) {
        emit(
          GetAllCategoriesErrorState(
            failure.message,
            errorType: ErrorType.normal,
          ),
        );
      }
    }, (categories) {
      emit(GetAllCategoriesSuccessState(categories));
    });
  }
}

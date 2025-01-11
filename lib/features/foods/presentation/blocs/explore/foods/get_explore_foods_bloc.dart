import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/features/categories/domain/entities/category.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/foods/domain/usecases/foods/get_foods_by_category_usecase.dart';
import 'package:your_chef/features/foods/domain/usecases/foods/get_on_sale_foods_usecase.dart';
import 'package:your_chef/features/foods/domain/usecases/foods/get_popular_foods_usecase.dart';

part 'get_explore_foods_events.dart';
part 'get_explore_foods_states.dart';

class GetExploreFoodsBloc
    extends Bloc<GetExploreFoodsEvent, GetExploreFoodsState> {
  final GetPopularFoodsUseCase getPopularFoodsUseCase;
  final GetOnSaleFoodsUseCase getOnSaleFoodsUseCase;
  final GetFoodsByCategoryUseCase getFoodsByCategoryUseCase;

  GetExploreFoodsBloc(this.getPopularFoodsUseCase, this.getOnSaleFoodsUseCase,
      this.getFoodsByCategoryUseCase)
      : super(
          const GetExploreFoodsState(),
        ) {
    on<GetExploreRefreshFoodsEvent>(_refreshFoods, transformer: droppable());
    on<GetExplorePopularFoodsEvent>(_getPopularFoods, transformer: droppable());
    on<GetExploreOnASaleFoodsEvent>(_getOnASaleFoods, transformer: droppable());
    on<GetExploreFoodsByCategoryEvent>(_getFoodsByCategory,
        transformer: droppable());
  }

  FutureOr<void> _getPopularFoods(GetExplorePopularFoodsEvent event,
      Emitter<GetExploreFoodsState> emit) async {
    emit(
      state.copyWith(
        status: RequestStatus.loading,
        foods: event.options.page == 1 ? [] : state.foods,
      ),
    );

    final Either<Failure, List<Food>> result =
        await getPopularFoodsUseCase(event.options);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RequestStatus.failure,
          error: failure.message,
          errorType: switch (failure.runtimeType) {
            const (NetworkFailure) => ErrorType.network,
            const (AuthFailure) => ErrorType.auth,
            const (ServerFailure) => ErrorType.normal,
            _ => ErrorType.normal,
          },
        ),
      ),
      (foods) => emit(
        state.copyWith(
          status: RequestStatus.success,
          foods: [...state.foods, ...foods],
          end: foods.length < event.options.limit,
          page: event.options.page + 1,
        ),
      ),
    );
  }

  FutureOr<void> _getOnASaleFoods(GetExploreOnASaleFoodsEvent event,
      Emitter<GetExploreFoodsState> emit) async {
    emit(
      state.copyWith(
        status: RequestStatus.loading,
        foods: event.options.page == 1 ? [] : state.foods,
      ),
    );

    final Either<Failure, List<Food>> result =
        await getOnSaleFoodsUseCase(event.options);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RequestStatus.failure,
          error: failure.message,
          errorType: switch (failure.runtimeType) {
            const (NetworkFailure) => ErrorType.network,
            const (AuthFailure) => ErrorType.auth,
            const (ServerFailure) => ErrorType.normal,
            _ => ErrorType.normal,
          },
        ),
      ),
      (foods) => emit(
        state.copyWith(
          status: RequestStatus.success,
          foods: [...state.foods, ...foods],
          end: foods.length < event.options.limit,
          page: event.options.page + 1,
        ),
      ),
    );
  }

  FutureOr<void> _getFoodsByCategory(GetExploreFoodsByCategoryEvent event,
      Emitter<GetExploreFoodsState> emit) async {
    emit(
      state.copyWith(
        status: RequestStatus.loading,
        foods: event.options.page == 1 ? [] : state.foods,
      ),
    );

    final Either<Failure, List<Food>> result =
        await getFoodsByCategoryUseCase(event.options);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RequestStatus.failure,
          error: failure.message,
          errorType: switch (failure.runtimeType) {
            const (NetworkFailure) => ErrorType.network,
            const (AuthFailure) => ErrorType.auth,
            const (ServerFailure) => ErrorType.normal,
            _ => ErrorType.normal,
          },
        ),
      ),
      (foods) => emit(
        state.copyWith(
          status: RequestStatus.success,
          foods: [...state.foods, ...foods],
          end: foods.length < event.options.limit,
          page: event.options.page + 1,
        ),
      ),
    );
  }

  FutureOr<void> _refreshFoods(
      GetExploreRefreshFoodsEvent event, Emitter<GetExploreFoodsState> emit) {
    emit(const GetExploreFoodsState());
  }
}

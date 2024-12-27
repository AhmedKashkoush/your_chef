import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/foods/domain/usecases/wishlist/add_food_to_wishlist_usecase.dart';
import 'package:your_chef/features/foods/domain/usecases/wishlist/get_foods_wishlist_usecase.dart';
import 'package:your_chef/features/foods/domain/usecases/wishlist/remove_food_from_wishlist_usecase.dart';

part 'wishlist_events.dart';
part 'wishlist_states.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final GetFoodsWishlistUseCase getFoodsWishlistUseCase;
  final AddFoodToWishlistUseCase addFoodToWishlistUseCase;
  final RemoveFoodFromWishlistUseCase removeFoodFromWishlistUseCase;

  WishlistBloc(
    this.getFoodsWishlistUseCase,
    this.addFoodToWishlistUseCase,
    this.removeFoodFromWishlistUseCase,
  ) : super(
          const WishlistState(),
        ) {
    on<GetFoodsWishlistEvent>(
      _getFoodsWishlist,
      transformer: droppable(),
    );
    on<RefreshFoodsWishlistEvent>(_refreshFoodsWishlist);
    on<AddFoodToWishlistWishlistEvent>(_addFoodToWishlist,
        transformer: droppable());
    on<RemoveFoodFromWishlistWishlistEvent>(_removeFoodFromWishlist,
        transformer: droppable());
  }

  FutureOr<void> _getFoodsWishlist(
      GetFoodsWishlistEvent event, Emitter<WishlistState> emit) async {
    if (!state.foodsHasNext && event.options.page > 1) return;
    emit(
      state.copyWith(
        status: RequestStatus.loading,
        foods: event.options.page == 1 ? const [] : state.foods,
        addOrRemove: false,
      ),
    );

    final Either<Failure, List<Food>> result =
        await getFoodsWishlistUseCase(event.options);

    result.fold((failure) {
      if (failure is NetworkFailure) {
        emit(
          state.copyWith(
            error: failure.message,
            status: RequestStatus.failure,
            errorType: ErrorType.network,
            addOrRemove: false,
          ),
        );
      }
      if (failure is ServerFailure) {
        emit(
          state.copyWith(
            error: failure.message,
            status: RequestStatus.failure,
            errorType: ErrorType.normal,
            addOrRemove: false,
          ),
        );
      }
    }, (foods) {
      List<Food> oldFoods = state.foods;
      emit(
        state.copyWith(
          status: RequestStatus.success,
          foods: [...oldFoods, ...foods],
          foodsHasNext: foods.length < event.options.limit ? false : true,
          addOrRemove: false,
          error: '',
        ),
      );
    });
  }

  FutureOr<void> _refreshFoodsWishlist(
      RefreshFoodsWishlistEvent event, Emitter<WishlistState> emit) async {
    emit(
      state.copyWith(
        status: RequestStatus.loading,
        foods: const [],
        foodsHasNext: true,
        addOrRemove: false,
      ),
    );

    final Either<Failure, List<Food>> result =
        await getFoodsWishlistUseCase(event.options);

    result.fold((failure) {
      if (failure is NetworkFailure) {
        emit(
          state.copyWith(
            error: failure.message,
            status: RequestStatus.failure,
            errorType: ErrorType.network,
            addOrRemove: false,
          ),
        );
      }
      if (failure is ServerFailure) {
        emit(
          state.copyWith(
            error: failure.message,
            status: RequestStatus.failure,
            errorType: ErrorType.normal,
            addOrRemove: false,
          ),
        );
      }
    }, (foods) {
      List<Food> oldFoods = state.foods;
      emit(
        state.copyWith(
          status: RequestStatus.success,
          foods: [...oldFoods, ...foods],
          addOrRemove: false,
          error: '',
        ),
      );
    });
  }

  FutureOr<void> _addFoodToWishlist(
      AddFoodToWishlistWishlistEvent event, Emitter<WishlistState> emit) async {
    emit(state.copyWith(
      status: RequestStatus.loading,
      addOrRemove: true,
    ));

    final Either<Failure, Unit> result =
        await addFoodToWishlistUseCase(event.food);

    result.fold((failure) {
      if (failure is NetworkFailure) {
        emit(
          state.copyWith(
            error: failure.message,
            status: RequestStatus.failure,
            errorType: ErrorType.network,
            addOrRemove: true,
          ),
        );
      }
      if (failure is ServerFailure) {
        emit(
          state.copyWith(
            error: failure.message,
            status: RequestStatus.failure,
            errorType: ErrorType.normal,
            addOrRemove: true,
          ),
        );
      }
    }, (_) {
      List<Food> oldFoods = state.foods;

      emit(
        state.copyWith(
          status: RequestStatus.success,
          foods: [...oldFoods, event.food],
          addOrRemove: true,
          error: '',
        ),
      );
    });
  }

  FutureOr<void> _removeFoodFromWishlist(
      RemoveFoodFromWishlistWishlistEvent event,
      Emitter<WishlistState> emit) async {
    emit(state.copyWith(
      status: RequestStatus.loading,
      addOrRemove: true,
    ));

    final Either<Failure, Unit> result =
        await removeFoodFromWishlistUseCase(event.food);

    result.fold((failure) {
      if (failure is NetworkFailure) {
        emit(
          state.copyWith(
            error: failure.message,
            status: RequestStatus.failure,
            errorType: ErrorType.network,
            addOrRemove: true,
          ),
        );
      }
      if (failure is ServerFailure) {
        emit(
          state.copyWith(
            error: failure.message,
            status: RequestStatus.failure,
            errorType: ErrorType.normal,
            addOrRemove: true,
          ),
        );
      }
    }, (_) {
      List<Food> newFoods = List.from(state.foods);
      newFoods.remove(event.food);

      emit(
        state.copyWith(
          status: RequestStatus.success,
          foods: newFoods,
          addOrRemove: true,
          error: '',
        ),
      );
    });
  }
}

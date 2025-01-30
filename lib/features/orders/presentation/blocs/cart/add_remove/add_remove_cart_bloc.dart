import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/orders/domain/usecases/cart/add_food_to_cart_usecase.dart';
import 'package:your_chef/features/orders/domain/usecases/cart/remove_food_from_cart_usecase.dart';

part 'add_remove_cart_events.dart';
part 'add_remove_cart_states.dart';

class AddRemoveCartBloc extends Bloc<AddRemoveCartEvent, AddRemoveCartState> {
  final AddFoodToCartUseCase addFoodToCartUseCase;
  final RemoveFoodFromCartUseCase removeFoodFromCartUseCase;
  AddRemoveCartBloc(this.addFoodToCartUseCase, this.removeFoodFromCartUseCase)
      : super(const AddRemoveCartInitialState()) {
    on<AddToCartEvent>(
      _addToCart,
      transformer: droppable(),
    );
    on<RemoveFromCartEvent>(
      _removeFromCart,
      transformer: droppable(),
    );
  }

  FutureOr<void> _addToCart(
      AddToCartEvent event, Emitter<AddRemoveCartState> emit) async {
    emit(const AddToCartLoadingState());
    final result = await addFoodToCartUseCase(event.food);
    result.fold((failure) {
      emit(
        AddToCartFailureState(
          failure.message,
          errorType: switch (failure.runtimeType) {
            const (NetworkFailure) => ErrorType.network,
            const (AuthFailure) => ErrorType.auth,
            const (ServerFailure) => ErrorType.normal,
            _ => ErrorType.normal,
          },
        ),
      );
    }, (_) {
      emit(
        AddToCartSuccessState(
          AppStrings.foodAddedToCart.tr(),
        ),
      );
    });
  }

  FutureOr<void> _removeFromCart(
      RemoveFromCartEvent event, Emitter<AddRemoveCartState> emit) async {
    emit(const AddToCartLoadingState());
    final result = await removeFoodFromCartUseCase(event.food);
    result.fold((failure) {
      emit(
        AddToCartFailureState(
          failure.message,
          errorType: switch (failure.runtimeType) {
            const (NetworkFailure) => ErrorType.network,
            const (AuthFailure) => ErrorType.auth,
            const (ServerFailure) => ErrorType.normal,
            _ => ErrorType.normal,
          },
        ),
      );
    }, (_) {
      emit(
        AddToCartSuccessState(
          AppStrings.foodRemovedFromCart.tr(),
        ),
      );
    });
  }
}

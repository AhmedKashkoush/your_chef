import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/features/foods/domain/entities/cart_item.dart';
import 'package:your_chef/features/foods/domain/usecases/cart/decrement_cart_item_usecase.dart';
import 'package:your_chef/features/foods/domain/usecases/cart/increment_cart_item_usecase.dart';

part 'cart_quantity_events.dart';
part 'cart_quantity_states.dart';

class CartQuantityBloc extends Bloc<CartQuantityEvent, CartQuantityState> {
  final IncrementCartItemUseCase incrementCartItemUseCase;
  final DecrementCartItemUseCase decrementCartItemUseCase;
  CartQuantityBloc(this.incrementCartItemUseCase, this.decrementCartItemUseCase)
      : super(const CartQuantityInitialState()) {
    on<IncrementCartQuantityEvent>(
      _incrementCart,
      transformer: droppable(),
    );
    on<DecrementCartQuantityEvent>(
      _decrementCart,
      transformer: droppable(),
    );
  }

  FutureOr<void> _incrementCart(
      IncrementCartQuantityEvent event, Emitter<CartQuantityState> emit) async {
    emit(const CartQuantityLoadingState());
    final result = await incrementCartItemUseCase(event.item);
    result.fold((failure) {
      emit(
        CartQuantityFailureState(
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
        CartQuantitySuccessState(
          AppStrings.itemUpdated.tr(),
        ),
      );
    });
  }

  FutureOr<void> _decrementCart(
      DecrementCartQuantityEvent event, Emitter<CartQuantityState> emit) async {
    emit(const CartQuantityLoadingState());
    final result = await decrementCartItemUseCase(event.item);
    result.fold((failure) {
      emit(
        CartQuantityFailureState(
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
        CartQuantitySuccessState(
          AppStrings.itemUpdated.tr(),
        ),
      );
    });
  }
}

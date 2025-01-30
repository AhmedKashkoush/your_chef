import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/features/orders/domain/entities/cart_item.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/orders/domain/usecases/cart/empty_cart_usecase.dart';
import 'package:your_chef/features/orders/domain/usecases/cart/get_cart_usecase.dart';

part 'cart_events.dart';
part 'cart_states.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase getCartUseCase;
  // final GetCartTotalUseCase getCartTotalUseCase;
  // final GetCartFeesUseCase getCartFeesUseCase;
  final EmptyCartUseCase emptyCartUseCase;
  // final AddFoodToCartUseCase addFoodToCartUseCase;
  // final RemoveFoodFromCartUseCase removeFoodFromCartUseCase;
  // final IncrementCartItemUseCase incrementCartItemUseCase;
  // final DecrementCartItemUseCase decrementCartItemUseCase;
  CartBloc(
    this.getCartUseCase,
    // this.getCartTotalUseCase,
    // this.getCartFeesUseCase,
    this.emptyCartUseCase,
    // this.addFoodToCartUseCase,
    // this.removeFoodFromCartUseCase,
    // this.incrementCartItemUseCase,
    // this.decrementCartItemUseCase,
  ) : super(const CartState()) {
    on<GetCartEvent>(
      _getCart,
      transformer: restartable(),
    );
    on<UpdateCartEvent>(_updateCart);
    on<EmptyCartEvent>(_emptyCart);
    on<GetCartTotalEvent>(_getCartTotal);
    on<GetCartFeesEvent>(_getCartFees);
    // on<AddFoodToCartEvent>(
    //   _addFoodToCart,
    //   transformer: droppable(),
    // );
    // on<RemoveFoodFromCartEvent>(
    //   _removeFoodFromCart,
    //   transformer: droppable(),
    // );
    // on<IncrementCartItemEvent>(
    //   _incrementCartItem,
    //   transformer: droppable(),
    // );
    // on<DecrementCartItemEvent>(
    //   _decrementCartItem,
    //   transformer: droppable(),
    // );
  }

  FutureOr<void> _getCart(GetCartEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: RequestStatus.loading, message: ''));
    final result = await getCartUseCase();
    result.fold((failure) {
      emit(state.copyWith(
        status: RequestStatus.failure,
        error: failure.message,
        errorType: switch (failure.runtimeType) {
          const (NetworkFailure) => ErrorType.network,
          const (AuthFailure) => ErrorType.auth,
          const (ServerFailure) => ErrorType.normal,
          _ => ErrorType.normal,
        },
      ));
    }, (items) {
      emit(state.copyWith(
        items: items,
        status: RequestStatus.success,
        message: '',
      ));
      add(GetCartTotalEvent());
      add(GetCartFeesEvent());
    });
  }

  FutureOr<void> _updateCart(
      UpdateCartEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(
      items: event.cartItems,
      status: RequestStatus.success,
    ));
    add(GetCartTotalEvent());
    add(GetCartFeesEvent());
  }

  FutureOr<void> _emptyCart(
      EmptyCartEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: RequestStatus.loading));
    final result = await emptyCartUseCase();
    result.fold((failure) {
      emit(state.copyWith(
        status: RequestStatus.failure,
        error: failure.message,
        message: '',
        errorType: switch (failure.runtimeType) {
          const (NetworkFailure) => ErrorType.network,
          const (AuthFailure) => ErrorType.auth,
          const (ServerFailure) => ErrorType.normal,
          _ => ErrorType.normal,
        },
      ));
    }, (_) {
      emit(
        state.copyWith(
          status: RequestStatus.success,
          items: [],
          total: 0,
          fees: 0,
          message: '',
        ),
      );
      add(GetCartTotalEvent());
      add(GetCartFeesEvent());
    });
  }

  FutureOr<void> _getCartTotal(
      GetCartTotalEvent event, Emitter<CartState> emit) async {
    num total = 0;
    for (var item in state.items) {
      total += item.food.price * item.quantity;
    }
    emit(state.copyWith(total: total));
    // emit(state.copyWith(status: RequestStatus.loading));
    // final result = await getCartTotalUseCase();
    // result.fold((failure) {
    //   emit(state.copyWith(
    //     status: RequestStatus.failure,
    //     error: failure.message,
    //     message: '',
    //     errorType: switch (failure.runtimeType) {
    //       const (NetworkFailure) => ErrorType.network,
    //       const (AuthFailure) => ErrorType.auth,
    //       const (ServerFailure) => ErrorType.normal,
    //       _ => ErrorType.normal,
    //     },
    //   ));
    // }, (total) {
    //   emit(state.copyWith(
    //     total: total,
    //     status: RequestStatus.success,
    //     message: '',
    //   ));
    // });
  }

  FutureOr<void> _getCartFees(
      GetCartFeesEvent event, Emitter<CartState> emit) async {
    num fees = 0;
    for (var item in state.items) {
      fees += item.food.fees * item.quantity;
    }
    emit(state.copyWith(fees: fees));
    // emit(state.copyWith(status: RequestStatus.loading));
    // final result = await getCartFeesUseCase();
    // result.fold((failure) {
    //   emit(state.copyWith(
    //     status: RequestStatus.failure,
    //     error: failure.message,
    //     message: '',
    //     errorType: switch (failure.runtimeType) {
    //       const (NetworkFailure) => ErrorType.network,
    //       const (AuthFailure) => ErrorType.auth,
    //       const (ServerFailure) => ErrorType.normal,
    //       _ => ErrorType.normal,
    //     },
    //   ));
    // }, (fees) {
    //   emit(state.copyWith(
    //     fees: fees,
    //     status: RequestStatus.success,
    //     message: '',
    //   ));
    // });
  }

  // FutureOr<void> _addFoodToCart(
  //     AddFoodToCartEvent event, Emitter<CartState> emit) async {
  //   emit(state.copyWith(status: RequestStatus.loading));
  //   final result = await addFoodToCartUseCase(event.food);
  //   result.fold((failure) {
  //     emit(state.copyWith(
  //       status: RequestStatus.failure,
  //       error: failure.message,
  //       message: '',
  //       errorType: switch (failure.runtimeType) {
  //         const (NetworkFailure) => ErrorType.network,
  //         const (AuthFailure) => ErrorType.auth,
  //         const (ServerFailure) => ErrorType.normal,
  //         _ => ErrorType.normal,
  //       },
  //     ));
  //   }, (_) {
  //     emit(state.copyWith(
  //       status: RequestStatus.success,
  //       message: AppStrings.foodAddedToCart.tr(),
  //       items: [
  //         ...state.items,
  //         CartItem(id: event.food.id, food: event.food, quantity: 1),
  //       ],
  //     ));
  //     add(GetCartTotalEvent());
  //     add(GetCartFeesEvent());
  //   });
  // }

  // FutureOr<void> _removeFoodFromCart(
  //     RemoveFoodFromCartEvent event, Emitter<CartState> emit) async {
  //   emit(state.copyWith(status: RequestStatus.loading));
  //   final result = await removeFoodFromCartUseCase(event.food);
  //   result.fold((failure) {
  //     emit(state.copyWith(
  //       status: RequestStatus.failure,
  //       error: failure.message,
  //       message: '',
  //       errorType: switch (failure.runtimeType) {
  //         const (NetworkFailure) => ErrorType.network,
  //         const (AuthFailure) => ErrorType.auth,
  //         const (ServerFailure) => ErrorType.normal,
  //         _ => ErrorType.normal,
  //       },
  //     ));
  //   }, (_) {
  //     final newItems = List<CartItem>.from(state.items)
  //         .where((item) => item.id != event.food.id)
  //         .toList();
  //     emit(state.copyWith(
  //       status: RequestStatus.success,
  //       message: AppStrings.foodRemovedFromCart.tr(),
  //       items: newItems,
  //     ));
  //     add(GetCartTotalEvent());
  //     add(GetCartFeesEvent());
  //   });
  // }

  // FutureOr<void> _incrementCartItem(
  //     IncrementCartItemEvent event, Emitter<CartState> emit) async {
  //   emit(state.copyWith(status: RequestStatus.loading));
  //   final result = await incrementCartItemUseCase(event.item);
  //   result.fold((failure) {
  //     emit(state.copyWith(
  //       status: RequestStatus.failure,
  //       error: failure.message,
  //       message: '',
  //       errorType: switch (failure.runtimeType) {
  //         const (NetworkFailure) => ErrorType.network,
  //         const (AuthFailure) => ErrorType.auth,
  //         const (ServerFailure) => ErrorType.normal,
  //         _ => ErrorType.normal,
  //       },
  //     ));
  //   }, (_) {
  //     final index = state.items.indexWhere((item) => item.id == event.item.id);
  //     state.items
  //       ..removeWhere((item) => item.id == event.item.id)
  //       ..insert(index, event.item);
  //     emit(
  //       state.copyWith(
  //         status: RequestStatus.success,
  //         message: AppStrings.itemUpdated.tr(),
  //         items: state.items,
  //       ),
  //     );
  //     add(GetCartTotalEvent());
  //     add(GetCartFeesEvent());
  //   });
  // }

  // FutureOr<void> _decrementCartItem(
  //     DecrementCartItemEvent event, Emitter<CartState> emit) async {
  //   emit(state.copyWith(status: RequestStatus.loading));
  //   final result = await decrementCartItemUseCase(event.item);
  //   result.fold((failure) {
  //     emit(state.copyWith(
  //       status: RequestStatus.failure,
  //       error: failure.message,
  //       message: '',
  //       errorType: switch (failure.runtimeType) {
  //         const (NetworkFailure) => ErrorType.network,
  //         const (AuthFailure) => ErrorType.auth,
  //         const (ServerFailure) => ErrorType.normal,
  //         _ => ErrorType.normal,
  //       },
  //     ));
  //   }, (_) {
  //     final index = state.items.indexWhere((item) => item.id == event.item.id);
  //     state.items
  //       ..removeWhere((item) => item.id == event.item.id)
  //       ..insert(index, event.item);
  //     emit(
  //       state.copyWith(
  //         status: RequestStatus.success,
  //         message: AppStrings.itemUpdated.tr(),
  //         items: state.items,
  //       ),
  //     );
  //     add(GetCartTotalEvent());
  //     add(GetCartFeesEvent());
  //   });
  // }
}

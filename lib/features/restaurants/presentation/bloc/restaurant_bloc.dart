import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/features/home/domain/entities/offer.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/restaurants/domain/usecases/get_restaurant_menu_usecase.dart';
import 'package:your_chef/features/restaurants/domain/usecases/get_restaurant_offers_usecase.dart';

part 'restaurant_states.dart';
part 'restaurant_events.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final GetRestaurantOffersUseCase getOffersUseCase;
  final GetRestaurantMenuUseCase getMenuUseCase;

  RestaurantBloc(this.getOffersUseCase, this.getMenuUseCase)
      : super(const RestaurantState()) {
    on<GetDataEvent>(_getData);
  }

  FutureOr<void> _getData(
      GetDataEvent event, Emitter<RestaurantState> emit) async {
    emit(state.copyWith(status: RequestStatus.loading));
    final List<Offer> fetchedOffers = [];
    final List<Food> fetchedFoods = [];

    final List result = await Future.wait(
        [getOffersUseCase(event.options), getMenuUseCase(event.options)]);
    result[0].fold((failure) {
      if (failure is NetworkFailure) {
        emit(
          state.copyWith(
            error: failure.message,
            status: RequestStatus.failure,
            errorType: ErrorType.network,
          ),
        );
      }
      if (failure is ServerFailure) {
        emit(
          state.copyWith(
            error: failure.message,
            status: RequestStatus.failure,
            errorType: ErrorType.normal,
          ),
        );
      }
    }, (offers) => fetchedOffers.addAll(offers));
    if (state.status == RequestStatus.failure) return;
    result[1].fold((failure) {
      if (failure is NetworkFailure) {
        emit(
          state.copyWith(
            error: failure.message,
            status: RequestStatus.failure,
            errorType: ErrorType.network,
          ),
        );
      }

      if (failure is ServerFailure) {
        emit(
          state.copyWith(
            error: failure.message,
            status: RequestStatus.failure,
            errorType: ErrorType.normal,
          ),
        );
      }
    }, (foods) => fetchedFoods.addAll(foods));
    if (state.status == RequestStatus.failure) return;
    emit(
      state.copyWith(
        offers: fetchedOffers,
        foods: fetchedFoods,
        status: RequestStatus.success,
        error: '',
        errorType: ErrorType.normal,
      ),
    );
  }
}

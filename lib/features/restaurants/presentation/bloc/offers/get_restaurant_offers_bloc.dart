import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/offers/domain/entities/offer.dart';
import 'package:your_chef/features/offers/domain/usecases/get_restaurant_offers_usecase.dart';

part 'get_restaurant_offers_events.dart';
part 'get_restaurant_offers_states.dart';

class GetRestaurantOffersBloc
    extends Bloc<GetRestaurantOffersEvent, GetRestaurantOffersState> {
  final GetRestaurantOffersUseCase getOffersUseCase;

  GetRestaurantOffersBloc(this.getOffersUseCase)
      : super(const GetRestaurantOffersInitialState()) {
    on<GetRestaurantOffersEventStarted>(_getOffers);
  }

  FutureOr<void> _getOffers(GetRestaurantOffersEventStarted event,
      Emitter<GetRestaurantOffersState> emit) async {
    emit(const GetRestaurantOffersLoadingState());
    final Either<Failure, List<Offer>> result =
        await getOffersUseCase(event.options);
    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          emit(
            GetRestaurantOffersErrorState(
              failure.message,
              errorType: ErrorType.network,
            ),
          );
        }
        if (failure is ServerFailure) {
          emit(
            GetRestaurantOffersErrorState(
              failure.message,
              errorType: ErrorType.normal,
            ),
          );
        }
      },
      (offers) => emit(
        GetRestaurantOffersSuccessState(offers),
      ),
    );
  }
}

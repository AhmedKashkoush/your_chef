import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';
import 'package:your_chef/features/restaurants/domain/usecases/get_popular_restaurants_usecase.dart';

part 'get_home_restaurants_events.dart';
part 'get_home_restaurants_states.dart';

class GetHomeRestaurantsBloc
    extends Bloc<GetHomeRestaurantsEvent, GetHomeRestaurantsState> {
  final GetPopularRestaurantsUseCase getRestaurantsUseCase;
  GetHomeRestaurantsBloc(this.getRestaurantsUseCase)
      : super(const GetHomeRestaurantsInitialState()) {
    on<GetHomeRestaurantsEventStarted>(_getRestaurants);
  }

  FutureOr<void> _getRestaurants(GetHomeRestaurantsEventStarted event,
      Emitter<GetHomeRestaurantsState> emit) async {
    emit(const GetHomeRestaurantsLoadingState());
    final Either<Failure, List<Restaurant>> result =
        await getRestaurantsUseCase();
    result.fold((failure) {
      if (failure is NetworkFailure) {
        emit(
          GetHomeRestaurantsErrorState(
            failure.message,
            errorType: ErrorType.network,
          ),
        );
      }
      if (failure is ServerFailure) {
        emit(
          GetHomeRestaurantsErrorState(
            failure.message,
            errorType: ErrorType.normal,
          ),
        );
      }
    }, (restaurants) {
      emit(GetHomeRestaurantsSuccessState(restaurants));
    });
  }
}

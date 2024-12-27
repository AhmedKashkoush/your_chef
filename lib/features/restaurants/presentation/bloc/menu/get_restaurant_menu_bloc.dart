import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/foods/domain/usecases/foods/get_restaurant_foods_usecase.dart';

part 'get_restaurant_menu_events.dart';
part 'get_restaurant_menu_states.dart';

class GetRestaurantMenuBloc
    extends Bloc<GetRestaurantMenuEvent, GetRestaurantMenuState> {
  final GetRestaurantFoodsUseCase getMenuUseCase;
  GetRestaurantMenuBloc(this.getMenuUseCase)
      : super(const GetRestaurantMenuInitialState()) {
    on<GetRestaurantMenuEventStarted>(_getMenu);
  }

  FutureOr<void> _getMenu(GetRestaurantMenuEventStarted event,
      Emitter<GetRestaurantMenuState> emit) async {
    emit(const GetRestaurantMenuLoadingState());
    final Either<Failure, List<Food>> result =
        await getMenuUseCase(event.options);
    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          emit(
            GetRestaurantMenuErrorState(
              failure.message,
              errorType: ErrorType.network,
            ),
          );
        }
        if (failure is ServerFailure) {
          emit(
            GetRestaurantMenuErrorState(
              failure.message,
              errorType: ErrorType.normal,
            ),
          );
        }
      },
      (foods) => emit(
        GetRestaurantMenuSuccessState(foods),
      ),
    );
  }
}

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/foods/domain/usecases/foods/get_popular_foods_usecase.dart';

part 'get_home_popular_foods_events.dart';
part 'get_home_popular_foods_states.dart';

class GetHomePopularFoodsBloc
    extends Bloc<GetHomePopularFoodsEvent, GetHomePopularFoodsState> {
  final GetPopularFoodsUseCase getPopularProductsUseCase;

  GetHomePopularFoodsBloc(this.getPopularProductsUseCase)
      : super(const GetHomePopularFoodsInitialState()) {
    on<GetHomePopularFoodsEventStarted>(_getPopularFoods);
  }

  FutureOr<void> _getPopularFoods(GetHomePopularFoodsEventStarted event,
      Emitter<GetHomePopularFoodsState> emit) async {
    emit(const GetHomePopularFoodsLoadingState());
    final Either<Failure, List<Food>> result =
        await getPopularProductsUseCase();
    result.fold((failure) {
      if (failure is NetworkFailure) {
        emit(
          GetHomePopularFoodsErrorState(
            failure.message,
            errorType: ErrorType.network,
          ),
        );
      }
      if (failure is ServerFailure) {
        emit(
          GetHomePopularFoodsErrorState(
            failure.message,
            errorType: ErrorType.normal,
          ),
        );
      }
    }, (foods) => emit(GetHomePopularFoodsSuccessState(foods)));
  }
}

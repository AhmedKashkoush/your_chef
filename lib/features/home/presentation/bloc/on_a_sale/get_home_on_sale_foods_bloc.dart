import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/foods/domain/usecases/foods/get_on_sale_foods_usecase.dart';

part 'get_home_on_sale_foods_events.dart';
part 'get_home_on_sale_foods_states.dart';

class GetHomeOnSaleFoodsBloc
    extends Bloc<GetHomeOnSaleFoodsEvent, GetHomeOnSaleFoodsState> {
  final GetOnSaleFoodsUseCase getOnSaleProductsUseCase;

  GetHomeOnSaleFoodsBloc(this.getOnSaleProductsUseCase)
      : super(const GetHomeOnSaleFoodsInitialState()) {
    on<GetHomeOnSaleFoodsEventStarted>(_getOnSaleFoods);
  }

  FutureOr<void> _getOnSaleFoods(GetHomeOnSaleFoodsEventStarted event,
      Emitter<GetHomeOnSaleFoodsState> emit) async {
    emit(const GetHomeOnSaleFoodsLoadingState());
    final Either<Failure, List<Food>> result =
        await getOnSaleProductsUseCase(event.options);
    result.fold((failure) {
      if (failure is NetworkFailure) {
        emit(
          GetHomeOnSaleFoodsErrorState(
            failure.message,
            errorType: ErrorType.network,
          ),
        );
      }
      if (failure is ServerFailure) {
        emit(
          GetHomeOnSaleFoodsErrorState(
            failure.message,
            errorType: ErrorType.normal,
          ),
        );
      }
    }, (foods) => emit(GetHomeOnSaleFoodsSuccessState(foods)));
  }
}

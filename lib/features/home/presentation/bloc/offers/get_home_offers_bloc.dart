import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/errors/failures.dart';
import 'package:your_chef/features/offers/domain/entities/offer.dart';
import 'package:your_chef/features/offers/domain/usecases/get_offers_usecase.dart';

part 'get_home_offers_events.dart';
part 'get_home_offers_states.dart';

class GetHomeOffersBloc extends Bloc<GetHomeOffersEvent, GetHomeOffersState> {
  final GetOffersUseCase getOffersUseCase;

  GetHomeOffersBloc(this.getOffersUseCase)
      : super(const GetHomeOffersInitialState()) {
    on<GetHomeOffersEvent>(_getOffers);
  }

  Future<void> _getOffers(
      GetHomeOffersEvent event, Emitter<GetHomeOffersState> emit) async {
    emit(const GetHomeOffersLoadingState());
    final Either<Failure, List<Offer>> result = await getOffersUseCase();
    result.fold((failure) {
      if (failure is NetworkFailure) {
        emit(
          GetHomeOffersErrorState(
            failure.message,
            errorType: ErrorType.network,
          ),
        );
      }
      if (failure is ServerFailure) {
        emit(
          GetHomeOffersErrorState(
            failure.message,
            errorType: ErrorType.normal,
          ),
        );
      }
    }, (offers) {
      emit(GetHomeOffersSuccessState(offers));
    });
  }
}

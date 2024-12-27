part of 'get_home_offers_bloc.dart';

sealed class GetHomeOffersState extends Equatable {
  const GetHomeOffersState();

  @override
  List<Object> get props => [];
}

class GetHomeOffersInitialState extends GetHomeOffersState {
  const GetHomeOffersInitialState();
}

class GetHomeOffersLoadingState extends GetHomeOffersState {
  const GetHomeOffersLoadingState();
}

class GetHomeOffersSuccessState extends GetHomeOffersState {
  final List<Offer> offers;

  const GetHomeOffersSuccessState(this.offers);

  @override
  List<Object> get props => [offers];
}

class GetHomeOffersErrorState extends GetHomeOffersState {
  final String error;
  final ErrorType errorType;
  const GetHomeOffersErrorState(this.error,
      {this.errorType = ErrorType.normal});

  @override
  List<Object> get props => [error, errorType];
}

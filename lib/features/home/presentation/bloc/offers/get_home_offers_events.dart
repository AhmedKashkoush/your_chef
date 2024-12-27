part of 'get_home_offers_bloc.dart';

sealed class GetHomeOffersEvent extends Equatable {
  const GetHomeOffersEvent();

  @override
  List<Object> get props => [];
}

class GetHomeOffersEventStarted extends GetHomeOffersEvent {
  const GetHomeOffersEventStarted();
}

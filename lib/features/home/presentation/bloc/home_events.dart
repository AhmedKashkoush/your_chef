part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class GetHomeDataEvent extends HomeEvent {
  const GetHomeDataEvent();
  @override
  List<Object?> get props => [];
}

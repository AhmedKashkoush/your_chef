part of 'get_home_on_sale_foods_bloc.dart';

sealed class GetHomeOnSaleFoodsEvent extends Equatable {
  const GetHomeOnSaleFoodsEvent();

  @override
  List<Object?> get props => [];
}

class GetHomeOnSaleFoodsEventStarted extends GetHomeOnSaleFoodsEvent {
  const GetHomeOnSaleFoodsEventStarted();
}

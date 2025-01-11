part of 'get_explore_foods_bloc.dart';

class GetExploreFoodsState extends Equatable {
  final List<Food> foods;
  final RequestStatus status;
  final String error;
  final ErrorType errorType;
  final bool end;
  final int page;
  const GetExploreFoodsState({
    this.foods = const [],
    this.status = RequestStatus.initial,
    this.error = '',
    this.errorType = ErrorType.normal,
    this.end = false,
    this.page = 1,
  });

  GetExploreFoodsState copyWith({
    List<Food>? foods,
    RequestStatus? status,
    String? error,
    ErrorType? errorType,
    bool? end,
    int? page,
  }) {
    return GetExploreFoodsState(
      foods: foods ?? this.foods,
      status: status ?? this.status,
      error: error ?? this.error,
      errorType: errorType ?? this.errorType,
      end: end ?? this.end,
      page: page ?? this.page,
    );
  }

  @override
  List<Object> get props => [
        foods,
        status,
        error,
        errorType,
        end,
        page,
      ];
}

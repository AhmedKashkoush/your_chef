part of 'home_bloc.dart';

class HomeState extends Equatable {
  final List<Offer> offers;
  final List<Category> categories;
  final List<Restaurant> restaurants;
  final List<Product> popularProducts;
  final List<Product> onSaleProducts;
  final RequestStatus status;
  final ErrorType errorType;
  final String error;

  const HomeState({
    this.offers = const [],
    this.categories = const [],
    this.restaurants = const [],
    this.popularProducts = const [],
    this.onSaleProducts = const [],
    this.status = RequestStatus.initial,
    this.error = '',
    this.errorType = ErrorType.normal,
  });

  HomeState copyWith({
    List<Offer>? offers,
    List<Category>? categories,
    List<Restaurant>? restaurants,
    List<Product>? popularProducts,
    List<Product>? onSaleProducts,
    RequestStatus? status,
    String? error,
    ErrorType? errorType,
  }) =>
      HomeState(
        offers: offers ?? this.offers,
        categories: categories ?? this.categories,
        restaurants: restaurants ?? this.restaurants,
        popularProducts: popularProducts ?? this.popularProducts,
        onSaleProducts: onSaleProducts ?? this.onSaleProducts,
        status: status ?? this.status,
        error: error ?? this.error,
        errorType: errorType ?? this.errorType,
      );

  @override
  List<Object?> get props => [
        offers,
        categories,
        restaurants,
        popularProducts,
        status,
        error,
        errorType,
      ];
}

import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id, categoryId, restaurantId;
  final String name, description;
  final List<String> images;
  final num price, rate, sale;
  final bool trending;

  const Product({
    required this.id,
    required this.categoryId,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.images,
    required this.price,
    required this.rate,
    required this.sale,
    required this.trending,
  });

  @override
  List<Object?> get props => [
        id,
        categoryId,
        restaurantId,
        name,
        description,
        images,
        price,
        rate,
        sale,
        trending,
      ];
}

import 'package:equatable/equatable.dart';
import 'package:your_chef/features/categories/domain/entities/category.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';

class Food extends Equatable {
  final int id, stock;
  final Category category;
  final Restaurant restaurant;
  final String name, description;
  final List<String> images;
  final num price, rate, sale, fees;
  final bool trending;

  const Food({
    required this.id,
    required this.stock,
    required this.category,
    required this.restaurant,
    required this.name,
    required this.description,
    required this.images,
    required this.price,
    required this.fees,
    required this.rate,
    required this.sale,
    required this.trending,
  });

  @override
  List<Object?> get props => [
        id,
        stock,
        category,
        restaurant,
        name,
        description,
        images,
        price,
        fees,
        rate,
        sale,
        trending,
      ];
}

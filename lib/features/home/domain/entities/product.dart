import 'package:equatable/equatable.dart';
import 'package:your_chef/features/home/domain/entities/category.dart';
import 'package:your_chef/features/home/domain/entities/restaurant.dart';

class Product extends Equatable {
  final int id;
  final Category category;
  final Restaurant restaurant;
  final String name, description;
  final List<String> images;
  final num price, rate, sale;
  final bool trending;

  const Product({
    required this.id,
    required this.category,
    required this.restaurant,
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
        category,
        restaurant,
        name,
        description,
        images,
        price,
        rate,
        sale,
        trending,
      ];
}

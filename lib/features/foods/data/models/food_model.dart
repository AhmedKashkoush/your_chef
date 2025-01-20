import 'package:equatable/equatable.dart';
import 'package:your_chef/features/categories/data/models/category_model.dart';
import 'package:your_chef/features/restaurants/data/models/restaurant_model.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';

class FoodModel extends Equatable {
  final int id, stock;
  final String name, description;
  final CategoryModel category;
  final RestaurantModel restaurant;
  final List<String> images;
  final num price, fees, rate, sale;
  final bool trending;

  const FoodModel({
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

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'] ?? 0,
      stock: json['stock'] ?? 0,
      category: CategoryModel.fromJson(json['category'] ?? {}),
      restaurant: RestaurantModel.fromJson(json['restaurant'] ?? {}),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      price: json['price'] ?? 0,
      fees: json['fees'] ?? 0,
      rate: json['rate'] ?? 0,
      sale: json['sale'] ?? 0,
      trending: json['trending'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'stock': stock,
        'category': category.toJson(),
        'restaurant': restaurant.toJson(),
        'name': name,
        'description': description,
        'images': images,
        'price': price,
        'fees': fees,
        'rate': rate,
        'sale': sale,
        'trending': trending,
      };

  factory FoodModel.fromEntity(Food food) => FoodModel(
        id: food.id,
        stock: food.stock,
        category: CategoryModel.fromEntity(food.category),
        restaurant: RestaurantModel.fromEntity(food.restaurant),
        name: food.name,
        description: food.description,
        images: food.images,
        price: food.price,
        fees: food.fees,
        rate: food.rate,
        sale: food.sale,
        trending: food.trending,
      );

  Food toEntity() => Food(
        id: id,
        stock: stock,
        category: category.toEntity(),
        restaurant: restaurant.toEntity(),
        name: name,
        description: description,
        images: images,
        price: price,
        fees: fees,
        rate: rate,
        sale: sale,
        trending: trending,
      );

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

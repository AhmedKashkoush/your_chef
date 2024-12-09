import 'package:equatable/equatable.dart';
import 'package:your_chef/features/home/data/models/category_model.dart';
import 'package:your_chef/features/home/data/models/restaurant_model.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';

class ProductModel extends Equatable {
  final int id;
  final String name, description;
  final CategoryModel category;
  final RestaurantModel restaurant;
  final List<String> images;
  final num price, rate, sale;
  final bool trending;

  const ProductModel({
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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      category: CategoryModel.fromJson(json['category']),
      restaurant: RestaurantModel.fromJson(json['restaurant']),
      name: json['name'],
      description: json['description'],
      images: List<String>.from(json['images']),
      price: json['price'],
      rate: json['rate'],
      sale: json['sale'],
      trending: json['trending'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category.toJson(),
        'restaurant': restaurant.toJson(),
        'name': name,
        'description': description,
        'images': images,
        'price': price,
        'rate': rate,
        'sale': sale,
        'trending': trending,
      };

  factory ProductModel.fromEntity(Product product) => ProductModel(
        id: product.id,
        category: CategoryModel.fromEntity(product.category),
        restaurant: RestaurantModel.fromEntity(product.restaurant),
        name: product.name,
        description: product.description,
        images: product.images,
        price: product.price,
        rate: product.rate,
        sale: product.sale,
        trending: product.trending,
      );

  Product toEntity() => Product(
        id: id,
        category: category.toEntity(),
        restaurant: restaurant.toEntity(),
        name: name,
        description: description,
        images: images,
        price: price,
        rate: rate,
        sale: sale,
        trending: trending,
      );

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

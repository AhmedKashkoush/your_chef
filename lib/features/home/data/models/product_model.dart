import 'package:equatable/equatable.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';

class ProductModel extends Equatable {
  final int id, categoryId, restaurantId;
  final String name, description;
  final List<String> images;
  final num price, rate, sale;
  final bool trending;

  const ProductModel({
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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      categoryId: json['category_id'],
      restaurantId: json['restaurant_id'],
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
        'category_id': categoryId,
        'restaurant_id': restaurantId,
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
        categoryId: product.categoryId,
        restaurantId: product.restaurantId,
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
        categoryId: categoryId,
        restaurantId: restaurantId,
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

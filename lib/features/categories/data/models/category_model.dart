import 'package:equatable/equatable.dart';
import 'package:your_chef/features/categories/domain/entities/category.dart';

class CategoryModel extends Equatable {
  final int id;
  final String name, image;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'],
        name: json['name'],
        image: json['image'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
      };

  factory CategoryModel.fromEntity(Category entity) => CategoryModel(
        id: entity.id,
        name: entity.name,
        image: entity.image,
      );

  Category toEntity() => Category(
        id: id,
        name: name,
        image: image,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        image,
      ];
}

import 'package:equatable/equatable.dart';
import 'package:your_chef/features/auth/data/models/user_model.dart';
import 'package:your_chef/features/foods/data/models/food_model.dart';
import 'package:your_chef/features/foods/domain/entities/food_review.dart';

class FoodReviewModel extends Equatable {
  final int id;
  final UserModel user;
  final FoodModel food;
  final String review;
  final double rate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FoodReviewModel({
    required this.id,
    required this.user,
    required this.food,
    required this.review,
    required this.rate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FoodReviewModel.fromJson(Map<String, dynamic> json) =>
      FoodReviewModel(
        id: json['id'] as int,
        user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
        food: FoodModel.fromJson(json['food'] as Map<String, dynamic>),
        review: json['review'] ?? '',
        rate: json['rate'] as double,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user.toJson(),
        'food': food.toJson(),
        'review': review,
        'rate': rate,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory FoodReviewModel.fromEntity(FoodReview entity) => FoodReviewModel(
        id: entity.id,
        user: UserModel.fromEntity(entity.user),
        food: FoodModel.fromEntity(entity.food),
        review: entity.review,
        rate: entity.rate,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  FoodReview toEntity() => FoodReview(
        id: id,
        user: user.toEntity(),
        food: food.toEntity(),
        review: review,
        rate: rate,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  @override
  List<Object?> get props =>
      [id, user, food, review, rate, createdAt, updatedAt];
}

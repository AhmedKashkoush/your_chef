import 'package:equatable/equatable.dart';
import 'package:your_chef/features/auth/domain/entities/user.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';

class FoodReview extends Equatable {
  final int id;
  final User user;
  final Food food;
  final String review;
  final double rate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FoodReview({
    required this.id,
    required this.user,
    required this.food,
    required this.review,
    required this.rate,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props =>
      [id, user, food, review, rate, createdAt, updatedAt];
}

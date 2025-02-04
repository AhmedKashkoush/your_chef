import 'package:equatable/equatable.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';

class CartItem extends Equatable {
  final int id, quantity;
  final Food food;

  const CartItem({
    required this.id,
    required this.food,
    required this.quantity,
  });

  CartItem copyWith({
    int? id,
    int? quantity,
    Food? food,
  }) =>
      CartItem(
        id: id ?? this.id,
        quantity: quantity ?? this.quantity,
        food: food ?? this.food,
      );

  @override
  List<Object?> get props => [id, food, quantity];
}

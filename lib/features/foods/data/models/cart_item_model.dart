import 'package:equatable/equatable.dart';
import 'package:your_chef/features/foods/data/models/food_model.dart';
import 'package:your_chef/features/foods/domain/entities/cart_item.dart';

class CartItemModel extends Equatable {
  final int id, quantity;
  final FoodModel food;

  const CartItemModel({
    required this.id,
    required this.food,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        id: json['id'],
        food: FoodModel.fromJson(json['food']),
        quantity: json['quantity'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'food': food.toJson(),
        'quantity': quantity,
      };

  factory CartItemModel.fromEntity(CartItem cartItem) => CartItemModel(
        id: cartItem.id,
        food: FoodModel.fromEntity(cartItem.food),
        quantity: cartItem.quantity,
      );

  CartItem toEntity() => CartItem(
        id: id,
        food: food.toEntity(),
        quantity: quantity,
      );

  @override
  List<Object?> get props => [id, food, quantity];
}

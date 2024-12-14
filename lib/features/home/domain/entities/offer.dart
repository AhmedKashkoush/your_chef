import 'package:equatable/equatable.dart';
import 'package:your_chef/features/home/domain/entities/restaurant.dart';

class Offer extends Equatable {
  final int id;
  final String image;
  final Restaurant restaurant;

  const Offer({
    required this.id,
    required this.restaurant,
    required this.image,
  });

  @override
  List<Object?> get props => [id, restaurant, image];
}

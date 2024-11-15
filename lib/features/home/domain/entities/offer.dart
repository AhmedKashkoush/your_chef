import 'package:equatable/equatable.dart';

class Offer extends Equatable {
  final int id, restaurantId;
  final String image;

  const Offer({
    required this.id,
    required this.restaurantId,
    required this.image,
  });

  @override
  List<Object?> get props => [id, restaurantId, image];
}

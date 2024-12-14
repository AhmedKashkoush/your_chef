import 'package:equatable/equatable.dart';
import 'package:your_chef/features/home/data/models/restaurant_model.dart';
import 'package:your_chef/features/home/domain/entities/offer.dart';

class OfferModel extends Equatable {
  final int id;
  final String image;
  final RestaurantModel restaurant;

  const OfferModel({
    required this.id,
    required this.restaurant,
    required this.image,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        id: json['id'],
        restaurant: RestaurantModel.fromJson(json['restaurant']),
        image: json['image'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
      };

  factory OfferModel.fromEntity(Offer entity) => OfferModel(
        id: entity.id,
        restaurant: RestaurantModel.fromEntity(entity.restaurant),
        image: entity.image,
      );

  Offer toEntity() => Offer(
        id: id,
        restaurant: restaurant.toEntity(),
        image: image,
      );

  @override
  List<Object?> get props => [
        id,
        restaurant,
        image,
      ];
}

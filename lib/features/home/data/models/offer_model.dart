import 'package:equatable/equatable.dart';
import 'package:your_chef/features/home/domain/entities/offer.dart';

class OfferModel extends Equatable {
  final int id, restaurantId;
  final String image;

  const OfferModel({
    required this.id,
    required this.restaurantId,
    required this.image,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        id: json['id'],
        restaurantId: json['restaurant_id'],
        image: json['image'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
      };

  factory OfferModel.fromEntity(Offer entity) => OfferModel(
        id: entity.id,
        restaurantId: entity.restaurantId,
        image: entity.image,
      );

  Offer toEntity() => Offer(
        id: id,
        restaurantId: restaurantId,
        image: image,
      );

  @override
  List<Object?> get props => [
        id,
        restaurantId,
        image,
      ];
}

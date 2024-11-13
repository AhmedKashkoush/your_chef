import 'package:equatable/equatable.dart';
import 'package:your_chef/features/home/domain/entities/offer.dart';

class OfferModel extends Equatable {
  final int id;
  final String image;

  const OfferModel({
    required this.id,
    required this.image,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        id: json['id'],
        image: json['image'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
      };

  factory OfferModel.fromEntity(Offer entity) => OfferModel(
        id: entity.id,
        image: entity.image,
      );

  Offer toEntity() => Offer(
        id: id,
        image: image,
      );

  @override
  List<Object?> get props => [
        id,
        image,
      ];
}

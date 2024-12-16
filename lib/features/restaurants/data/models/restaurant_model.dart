import 'package:equatable/equatable.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';

class RestaurantModel extends Equatable {
  final int id;
  final String name, phone, description, address, profileImage;
  final List<String> images;
  final num rate;
  final double latitude, longitude;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.description,
    required this.address,
    required this.profileImage,
    required this.images,
    required this.rate,
    required this.latitude,
    required this.longitude,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      description: json['description'],
      address: json['address'],
      profileImage: json['profile_image'],
      images: List<String>.from(json['images']),
      rate: json['rate'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'description': description,
        'address': address,
        'profile_image': profileImage,
        'images': images,
        'rate': rate,
        'latitude': latitude,
        'longitude': longitude,
      };

  factory RestaurantModel.fromEntity(Restaurant entity) => RestaurantModel(
        id: entity.id,
        name: entity.name,
        phone: entity.phone,
        description: entity.description,
        address: entity.address,
        profileImage: entity.profileImage,
        images: entity.images,
        rate: entity.rate,
        latitude: entity.latitude,
        longitude: entity.longitude,
      );

  Restaurant toEntity() => Restaurant(
        id: id,
        name: name,
        phone: phone,
        description: description,
        address: address,
        profileImage: profileImage,
        images: images,
        rate: rate,
        latitude: latitude,
        longitude: longitude,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        description,
        address,
        profileImage,
        images,
        rate,
        latitude,
        longitude,
      ];
}

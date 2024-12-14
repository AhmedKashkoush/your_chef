import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final int id;
  final String name, phone, description, address, profileImage;
  final List<String> images;
  final num rate;
  final double latitude, longitude;

  const Restaurant({
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
      ];
}

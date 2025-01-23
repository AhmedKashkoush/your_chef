import 'package:equatable/equatable.dart';
import 'package:your_chef/core/enums/gender.dart';

import '../../domain/entities/user.dart';

class UserModel extends Equatable {
  final String id, name, phone, email, address, image;
  final Gender? gender;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.image,
    required this.gender,
  });

  @override
  List<Object?> get props => [id, name, phone, email, address, image, gender];

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      image: json['image'],
      gender:
          json['gender'] != null ? Gender.values.byName(json['gender']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'image': image,
      'gender': gender?.name,
    };
  }

  User toEntity() => User(
        id: id,
        name: name,
        phone: phone,
        email: email,
        address: address,
        image: image,
        gender: gender,
      );

  factory UserModel.fromEntity(User user) => UserModel(
        id: user.id,
        name: user.name,
        phone: user.phone,
        email: user.email,
        address: user.address,
        image: user.image,
        gender: user.gender,
      );
}

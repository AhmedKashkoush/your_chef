import 'package:equatable/equatable.dart';
import 'package:your_chef/core/enums/gender.dart';

class User extends Equatable {
  final String id, name, phone, email, address, image;
  final Gender? gender;

  const User({
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
}

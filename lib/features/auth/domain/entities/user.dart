import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id, name, phone, email, address, image;

  const User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.image,
  });

  @override
  List<Object?> get props => [id, name, phone, email, address, image];
}

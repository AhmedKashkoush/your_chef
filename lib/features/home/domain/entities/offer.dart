import 'package:equatable/equatable.dart';

class Offer extends Equatable {
  final int id;
  final String image;

  const Offer({
    required this.id,
    required this.image,
  });

  @override
  List<Object?> get props => [id, image];
}

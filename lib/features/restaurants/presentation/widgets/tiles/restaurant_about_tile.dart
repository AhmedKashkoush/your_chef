import 'package:flutter/material.dart';
import 'package:your_chef/features/home/domain/entities/restaurant.dart';

class RestaurantAboutTile extends StatelessWidget {
  const RestaurantAboutTile({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
        'About us',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(restaurant.description),
    );
  }
}

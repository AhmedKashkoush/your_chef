import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/features/home/domain/entities/restaurant.dart';

class RestaurantContactTile extends StatelessWidget {
  const RestaurantContactTile({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
        'Contact us',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(restaurant.phone),
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(
          HugeIcons.strokeRoundedCall,
          color: Colors.green,
        ),
      ),
    );
  }
}

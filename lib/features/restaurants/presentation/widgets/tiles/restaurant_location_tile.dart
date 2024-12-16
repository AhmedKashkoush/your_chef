import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';

class RestaurantLocationTile extends StatelessWidget {
  const RestaurantLocationTile({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        HugeIcons.strokeRoundedLocation01,
        color: Colors.red,
      ),
      title: const Text(
        AppStrings.location,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        restaurant.address,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

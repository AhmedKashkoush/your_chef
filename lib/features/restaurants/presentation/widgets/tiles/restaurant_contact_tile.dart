import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';

class RestaurantContactTile extends StatelessWidget {
  const RestaurantContactTile({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        AppStrings.contactUs.tr(),
        style: const TextStyle(
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

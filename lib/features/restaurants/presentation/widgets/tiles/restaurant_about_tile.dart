import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';

class RestaurantAboutTile extends StatelessWidget {
  const RestaurantAboutTile({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        AppStrings.aboutUs.tr(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(restaurant.description),
    );
  }
}

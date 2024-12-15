import 'package:flutter/material.dart';
import 'package:your_chef/core/constants/strings.dart';

class RestaurantMenuTile extends StatelessWidget {
  const RestaurantMenuTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      title: Text(
        AppStrings.ourMenu,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

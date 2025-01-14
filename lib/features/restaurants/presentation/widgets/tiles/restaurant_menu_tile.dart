import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:your_chef/core/constants/strings.dart';

class RestaurantMenuTile extends StatelessWidget {
  const RestaurantMenuTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        AppStrings.ourMenu.tr(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

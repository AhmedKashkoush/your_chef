import 'package:flutter/material.dart';

class RestaurantMenuTile extends StatelessWidget {
  const RestaurantMenuTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      title: Text(
        'Our menu',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/features/home/domain/entities/restaurant.dart';
import 'package:your_chef/features/home/presentation/widgets/items/restaurant_item.dart';

class RestaurantsSection extends StatelessWidget {
  final List<Restaurant> restaurants;
  const RestaurantsSection({
    super.key,
    required this.restaurants,
  });

  final double _size = 200;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: SizedBox(
        height: _size,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: restaurants.length,
          separatorBuilder: (_, __) => 10.width,
          itemBuilder: (_, index) => RestaurantItem(
            restaurant: restaurants[index],
            size: _size,
          ),
        ),
      ),
    );
  }
}

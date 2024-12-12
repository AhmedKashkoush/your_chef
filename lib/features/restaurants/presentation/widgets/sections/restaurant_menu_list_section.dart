import 'package:flutter/material.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';
import 'package:your_chef/features/restaurants/presentation/widgets/items/restaurant_menu_item.dart';

class RestaurantMenuListSection extends StatelessWidget {
  const RestaurantMenuListSection({
    super.key,
    required this.foods,
    required this.tag,
  });

  final List<Product> foods;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (_, index) => RestaurantMenuItem(
        food: foods[index],
        tag: tag,
      ),
      separatorBuilder: (_, index) => 8.height,
      itemCount: foods.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}

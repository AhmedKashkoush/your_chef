import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/extensions/media_query_extension.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/core/widgets/items/food_item.dart';

class FoodsList extends StatelessWidget {
  final List<Food> foods;
  final bool loading;
  const FoodsList({
    super.key,
    required this.foods,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.isPortrait ? 2 : 3,
        crossAxisSpacing: 6.w,
        mainAxisSpacing: 6.h,
      ),
      shrinkWrap: true,
      primary: false,
      itemCount: foods.length,
      itemBuilder: (_, index) => FoodItem(
        food: foods[index],
        enableHero: !loading,
      ),
    );
  }
}

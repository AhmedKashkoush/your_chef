import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/restaurants/presentation/widgets/items/restaurant_menu_item.dart';

class RestaurantMenuListSection extends StatelessWidget {
  const RestaurantMenuListSection({
    super.key,
    required this.foods,
    required this.tag,
  });

  final List<Food> foods;
  final String tag;

  Widget _buildEmptyMenu(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            HugeIcons.strokeRoundedMenuRestaurant,
            size: 120.sp,
            color: AppColors.primary,
          ),
          10.height,
          Text(
            'We will add menu soon',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
              color: context.theme.iconTheme.color?.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Food> normalFoods =
        foods.where((food) => food.sale == 0).toList();
    final List<Food> saleFoods = foods.where((food) => food.sale > 0).toList();
    return foods.isEmpty
        ? _buildEmptyMenu(context)
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (saleFoods.isNotEmpty) ...[
                if (saleFoods.isNotEmpty && normalFoods.isNotEmpty)
                  ListTile(
                    title: Text(
                      AppStrings.onASale,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: context.theme.iconTheme.color?.withOpacity(0.5),
                      ),
                    ),
                  ),
                ListView.separated(
                  itemBuilder: (_, index) => RestaurantMenuItem(
                    food: saleFoods[index],
                    tag: tag,
                  ),
                  separatorBuilder: (_, index) => 8.height,
                  itemCount: saleFoods.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ],
              if (normalFoods.isNotEmpty) ...[
                if (saleFoods.isNotEmpty && normalFoods.isNotEmpty)
                  ListTile(
                    title: Text(
                      AppStrings.other,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: context.theme.iconTheme.color?.withOpacity(0.5),
                      ),
                    ),
                  ),
                ListView.separated(
                  itemBuilder: (_, index) => RestaurantMenuItem(
                    food: normalFoods[index],
                    tag: tag,
                  ),
                  separatorBuilder: (_, index) => 8.height,
                  itemCount: normalFoods.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ]
            ],
          );
  }
}

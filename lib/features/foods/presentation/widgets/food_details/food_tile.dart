import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';

class FoodTile extends StatelessWidget {
  const FoodTile({
    super.key,
    required this.food,
  });

  final Food food;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50.w,
        height: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              food.images.first,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        food.name,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          // color: context.theme.iconTheme.color?.withOpacity(0.6),
          fontWeight: FontWeight.bold,
          // fontSize: 18,
        ),
      ),
      subtitle: Text.rich(
        TextSpan(
          text: food.rate > 0 ? '${food.rate} ' : AppStrings.noRatings,
          children: food.rate > 0
              ? const [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.star_rounded,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ),
                ]
              : [],
        ),
        style: TextStyle(
          color: context.theme.iconTheme.color?.withOpacity(0.6),
          // fontSize: 18,
        ),
      ),
    );
  }
}

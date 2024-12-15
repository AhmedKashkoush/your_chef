import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/widgets/rating/star_rating_widget.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';

class RestaurantMenuItem extends StatelessWidget {
  const RestaurantMenuItem({
    super.key,
    required this.food,
    required this.tag,
  });

  final Product food;
  final String tag;

  @override
  Widget build(BuildContext context) {
    if (food.sale > 0) {
      return ClipRRect(
        clipBehavior: Clip.antiAlias,
        child: Banner(
          message:
              "${(food.sale * 100).toStringAsFixed(0)}% ${AppStrings.sale}",
          location: BannerLocation.topStart,
          child: _buildTile(context),
        ),
      );
    } else {
      return _buildTile(context);
    }
  }

  ListTile _buildTile(BuildContext context) {
    return ListTile(
      onTap: () => context.pushNamed(
        AppRoutes.product,
        arguments: {
          'food': food,
          'tag': tag,
        },
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12).r,
        child: Hero(
          tag: 'food$tag${food.id}image+0',
          child: CachedNetworkImage(
            imageUrl: food.images.first,
            fit: BoxFit.cover,
            width: 80.w,
            height: 80.h,
          ),
        ),
      ),
      title: Hero(
        tag: 'food$tag${food.id}name',
        child: Material(
          type: MaterialType.transparency,
          child: Text(
            food.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      subtitle: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              child: StarRatingWidget(
                rate: food.rate.toDouble(),
                size: 16.sp,
              ),
            ),
            TextSpan(
              text: ' (${food.rate})',
            ),
          ],
          style: TextStyle(
            color: context.theme.iconTheme.color?.withOpacity(0.6),
            fontSize: 16.sp,
          ),
        ),
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Hero(
            tag: 'food$tag${food.id}price',
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                '${(food.price - (food.price * food.sale)).toStringAsFixed(1)} ${AppStrings.egp}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (food.sale > 0)
            Text(
              '${food.price.toStringAsFixed(1)} ${AppStrings.egp}',
              style: TextStyle(
                fontSize: 12.sp,
                height: 0.8.h,
                color: context.theme.iconTheme.color?.withOpacity(0.6),
                decoration: TextDecoration.lineThrough,
              ),
            ),
        ],
      ),
    );
  }
}

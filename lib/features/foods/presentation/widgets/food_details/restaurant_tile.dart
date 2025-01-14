import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/widgets/rating/star_rating_widget.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';

class RestaurantTile extends StatelessWidget {
  const RestaurantTile({
    super.key,
    required this.restaurant,
    required this.tag,
  });

  final Restaurant restaurant;
  final String tag;

  String get _baseTag => 'restaurant${restaurant.id}';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0).r,
      child: ListTile(
        tileColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        leading: Hero(
          tag: "$_baseTag-image",
          child: Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  restaurant.profileImage,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        trailing: ElevatedButton(
          onPressed: () => context.pushNamed(
            AppRoutes.restaurant,
            arguments: {
              'restaurant': restaurant,
              'tag': tag,
            },
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
          ),
          child: Text(
            AppStrings.visit.tr(),
            style: const TextStyle(
              color: AppColors.primary,
            ),
          ),
        ),
        title: Hero(
          tag: "$_baseTag-name",
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              restaurant.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                // color: context.theme.iconTheme.color?.withOpacity(0.6),
                color: Colors.white,
                fontWeight: FontWeight.bold,
                // fontSize: 18,
              ),
            ),
          ),
        ),
        subtitle: Text.rich(
          TextSpan(
            children: [
              if (restaurant.rate > 0) ...[
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: StarRatingWidget(
                    rate: restaurant.rate.toDouble(),
                    rateColor: Colors.white,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: ' (${restaurant.rate})',
                ),
              ] else
                TextSpan(
                  text: AppStrings.noRatings.tr(),
                )
            ],
          ),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

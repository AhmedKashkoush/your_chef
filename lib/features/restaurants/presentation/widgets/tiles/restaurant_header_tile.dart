import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/widgets/rating/star_rating_widget.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';

class RestaurantHeaderTile extends StatelessWidget {
  const RestaurantHeaderTile({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 48.w,
        height: 48.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              restaurant.profileImage,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(restaurant.name),
      subtitle: Text.rich(
        TextSpan(
          children: [
            if (restaurant.rate > 0) ...[
              WidgetSpan(
                child: StarRatingWidget(
                  rate: restaurant.rate.toDouble(),
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
          style: TextStyle(
            color: context.theme.iconTheme.color?.withOpacity(0.6),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            WidgetSpan(
              child: StarRatingWidget(
                rate: restaurant.rate.toDouble(),
              ),
            ),
            TextSpan(
              text: ' (${restaurant.rate})',
            ),
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

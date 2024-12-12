import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/widgets/rating/star_rating_widget.dart';
import 'package:your_chef/features/home/domain/entities/restaurant.dart';

class RestaurantInfoSection extends StatelessWidget {
  const RestaurantInfoSection({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0).r,
      child: Row(
        children: [
          Hero(
            tag: "restaurant${restaurant.id}-${restaurant.profileImage}",
            child: Container(
              width: 100.w,
              height: 100.h,
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
          ),
          16.width,
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: "restaurant${restaurant.id}-${restaurant.name}",
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      restaurant.name,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                2.height,
                Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: StarRatingWidget(
                          rate: restaurant.rate.toDouble(),
                          size: 18.sp,
                        ),
                      ),
                      TextSpan(
                        text: ' (${restaurant.rate})',
                      ),
                    ],
                    style: TextStyle(
                      color: context.theme.iconTheme.color?.withOpacity(0.6),
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

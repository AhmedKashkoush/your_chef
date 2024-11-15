import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/features/home/domain/entities/restaurant.dart';

class RestaurantItem extends StatelessWidget {
  const RestaurantItem({
    super.key,
    required this.restaurant,
    required this.size,
  });
  final double size;
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Theme.of(context).iconTheme.color?.withOpacity(0.1),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(
            restaurant.profileImage,
          ),
        ),
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0).r,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Flexible(
                  child: 6.height,
                ),
                Text.rich(
                  TextSpan(
                    text: '${restaurant.rate} ',
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.star_rounded,
                          color: AppColors.primary,
                          size: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

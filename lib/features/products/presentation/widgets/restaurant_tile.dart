import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/widgets/rating/star_rating_widget.dart';
import 'package:your_chef/features/home/domain/entities/restaurant.dart';

class RestaurantTile extends StatelessWidget {
  const RestaurantTile({
    super.key,
    required this.restaurant,
    required this.tag,
  });

  final Restaurant restaurant;
  final String tag;

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
          tag: "restaurant${restaurant.id}-image",
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
          child: const Text(
            AppStrings.visit,
            style: TextStyle(
              color: AppColors.primary,
            ),
          ),
        ),
        title: Hero(
          tag: "restaurant${restaurant.id}-name",
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/widgets/rating/star_rating_widget.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';

class RestaurantItem extends StatelessWidget {
  const RestaurantItem({
    super.key,
    required this.restaurant,
    required this.size,
  });
  final double size;
  final Restaurant restaurant;

  final String _tag = 'food';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        AppRoutes.restaurant,
        arguments: {
          'restaurant': restaurant,
          'tag': _tag,
        },
      ),
      child: Container(
        width: size,
        height: size,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Stack(
          children: [
            Hero(
              tag: "restaurant${restaurant.id}-image",
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      restaurant.profileImage,
                    ),
                  ),
                ),
              ),
            ),
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: "restaurant${restaurant.id}-name",
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        restaurant.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: 6.height,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        if (restaurant.rate > 0) ...[
                          WidgetSpan(
                            child: StarRatingWidget(
                              rate: restaurant.rate.toDouble(),
                              size: 14,
                            ),
                          ),
                          TextSpan(
                            text: ' (${restaurant.rate})',
                          ),
                        ] else
                          const TextSpan(
                            text: AppStrings.noRatings,
                          )
                      ],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

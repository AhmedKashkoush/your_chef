import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
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
    this.enableHero = true,
  });
  final double size;
  final Restaurant restaurant;
  final bool enableHero;

  final String _tag = 'food';

  String get _baseTag => 'restaurant${restaurant.id}';

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
            HeroMode(
              enabled: enableHero,
              child: Hero(
                tag: "$_baseTag-image",
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
                  HeroMode(
                    enabled: enableHero,
                    child: Hero(
                      tag: "$_baseTag-name",
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
                          TextSpan(
                            text: AppStrings.noRatings.tr(),
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

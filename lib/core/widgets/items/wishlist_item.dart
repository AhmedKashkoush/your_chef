import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/widgets/buttons/custom_icon_button.dart';
import 'package:your_chef/core/widgets/buttons/primary_button.dart';
import 'package:your_chef/core/widgets/rating/star_rating_widget.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/common/blocs/wishlist/wishlist_bloc.dart';

class WishlistItem extends StatelessWidget {
  final Food food;
  final bool enableHero;
  const WishlistItem({
    super.key,
    required this.food,
    this.enableHero = true,
  });

  final String _tag = 'wishlist';

  String get _baseTag => 'food$_tag${food.id}';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoutes.food,
          arguments: {
            'food': food,
            'tag': _tag,
          },
        );
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: context.theme.scaffoldBackgroundColor,
        ),
        child: food.sale > 0
            ? Banner(
                message:
                    "${(food.sale * 100).toStringAsFixed(0)}% ${AppStrings.sale.tr()}",
                location: BannerLocation.topEnd,
                child: _buildItem(context),
              )
            : _buildItem(context),
      ),
    );
  }

  Widget _buildItem(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                HeroMode(
                  enabled: enableHero,
                  child: Hero(
                    tag: '${_baseTag}image+0',
                    child: Container(
                      // width: 120.w,
                      // height: 160.h,
                      decoration: BoxDecoration(
                        color: context.theme.iconTheme.color?.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            food.images.first,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                CustomIconButton(
                  icon: const Icon(HugeIcons.strokeRoundedHeartRemove),
                  onPressed: () {
                    context.read<WishlistBloc>().add(
                          RemoveFoodFromWishlistWishlistEvent(food),
                        );
                  },
                ),
              ],
            ),
          ),
          // Container(
          //   width: double.infinity,
          //   height: double.infinity,
          //   decoration: const BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //       colors: [
          //         Colors.transparent,
          //         Colors.black,
          //       ],
          //     ),
          //   ),
          // ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HeroMode(
                    enabled: enableHero,
                    child: Hero(
                      tag: '${_baseTag}name',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          food.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            height: 0.9,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  HeroMode(
                    enabled: enableHero,
                    child: Hero(
                      tag: '${_baseTag}description',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          food.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color:
                                context.theme.iconTheme.color?.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (food.sale > 0.0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HeroMode(
                          enabled: enableHero,
                          child: Hero(
                            tag: '${_baseTag}price',
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                '${(food.price - (food.price * food.sale)).toStringAsFixed(1)} ${AppStrings.egp.tr()}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.primary.withOpacity(0.8),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '${food.price} ${AppStrings.egp.tr()}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            height: 0.8,
                            color:
                                context.theme.iconTheme.color?.withOpacity(0.5),
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                            decorationColor:
                                context.theme.iconTheme.color?.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  else
                    HeroMode(
                      enabled: enableHero,
                      child: Hero(
                        tag: '${_baseTag}price',
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            '${food.price} ${AppStrings.egp.tr()}',
                            // maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.primary.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  2.height,
                  Text.rich(
                    TextSpan(
                      children: [
                        if (food.rate > 0) ...[
                          WidgetSpan(
                            child: StarRatingWidget(
                              rate: food.rate.toDouble(),
                              size: 14,
                            ),
                          ),
                          TextSpan(
                            text: ' (${food.rate})',
                          ),
                        ] else
                          TextSpan(
                            text: AppStrings.noRatings.tr(),
                          )
                      ],
                      style: TextStyle(
                        color: context.theme.iconTheme.color?.withOpacity(0.6),
                      ),
                    ),
                  ),
                  10.height,
                  PrimaryButton(
                    text: 'Add to cart',
                    icon: HugeIcons.strokeRoundedShoppingCart01,
                    onPressed: () {},
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

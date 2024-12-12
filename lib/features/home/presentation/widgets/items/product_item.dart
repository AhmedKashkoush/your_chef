import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';

class ProductItem extends StatelessWidget {
  final Product food;
  const ProductItem({
    super.key,
    required this.food,
  });

  final String _tag = 'product';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoutes.product,
          arguments: {
            'food': food,
            'tag': _tag,
          },
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        clipBehavior: Clip.antiAlias,
        child: food.sale > 0
            ? Banner(
                message: "${(food.sale * 100).toStringAsFixed(0)}% Sale",
                location: BannerLocation.topEnd,
                child: _buildItem(context),
              )
            : _buildItem(context),
      ),
    );
  }

  Stack _buildItem(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: 'food$_tag${food.id}${food.images.first}',
          child: Container(
            decoration: BoxDecoration(
              color: context.theme.iconTheme.color?.withOpacity(0.1),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  food.images.first,
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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'food$_tag${food.id}${food.name}',
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    food.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      height: 0.9,
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Hero(
                tag: 'food$_tag${food.id}${food.description}',
                child: Text(
                  food.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ),
              if (food.sale > 0.0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Hero(
                      tag:
                          'food$_tag${food.id}${food.price - (food.price * food.sale)}',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          '${(food.price - (food.price * food.sale)).toStringAsFixed(1)} EGP',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.primary.withOpacity(0.8),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Hero(
                      tag:
                          '$_tag${food.id}${food.price - (food.price * food.sale)}',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          '${food.price} EGP',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            height: 0.8,
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.white.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                Text(
                  '${food.price} EGP',
                  // maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.primary.withOpacity(0.8),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Flexible(
                child: 2.height,
              ),
              Text.rich(
                TextSpan(
                  text: '${food.rate} ',
                  children: const [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.star_rounded,
                        color: AppColors.primary,
                        size: 14,
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
    );
  }
}

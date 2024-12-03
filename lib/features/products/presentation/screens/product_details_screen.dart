import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/core/widgets/buttons/custom_icon_button.dart';
import 'package:your_chef/core/widgets/layout/orientation_widget.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';
import 'package:your_chef/features/wishlist/presentation/bloc/wishlist_bloc.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  final String tag;
  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationWidget(
        portrait: _ProductDetailsPortrait(
          product: product,
          tag: tag,
        ),
        landscape: _ProductDetailsLandscape(
          product: product,
          tag: tag,
        ),
      ),
    );
  }
}

class _ProductDetailsPortrait extends StatelessWidget {
  final Product product;
  final String tag;
  const _ProductDetailsPortrait({
    required this.product,
    required this.tag,
  });

  void _toggleFavorite(BuildContext context) {
    if (AppDummies.foodsWishlist
        .where((food) => food.id == product.id)
        .toList()
        .isEmpty) {
      context.read<WishlistBloc>().add(AddFoodToWishlistWishlistEvent(product));
    } else {
      context
          .read<WishlistBloc>()
          .add(RemoveFoodFromWishlistWishlistEvent(product));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          // floating: true,
          expandedHeight: 260.h,
          actions: [
            BlocConsumer<WishlistBloc, WishlistState>(
                listener: (context, state) {
              if (state.status == RequestStatus.loading) {
                AppMessages.showLoadingDialog(context,
                    message: 'Just a moment...');
              } else {
                Navigator.pop(context);
                if (state.status == RequestStatus.success) {
                  if (AppDummies.foodsWishlist
                      .where((food) => food.id == product.id)
                      .toList()
                      .isNotEmpty) {
                    AppMessages.showSuccessMessage(
                        context, 'Food added to your wishlist');
                  } else {
                    AppMessages.showSuccessMessage(
                        context, 'Food removed from your wishlist');
                  }
                }
                if (state.status == RequestStatus.failure) {
                  AppMessages.showErrorMessage(
                    context,
                    state.error,
                    state.errorType,
                  );
                }
              }
            }, builder: (context, state) {
              bool favorite = AppDummies.foodsWishlist
                  .where((food) => food.id == product.id)
                  .toList()
                  .isNotEmpty;
              return Padding(
                padding: const EdgeInsets.all(8.0).r,
                child: CustomIconButton(
                  icon: Icon(favorite
                      ? Icons.favorite
                      : HugeIcons.strokeRoundedFavourite),
                  onPressed: () => _toggleFavorite(context),
                ),
              );
            }),
          ],
          leading: context.canPop()
              ? Padding(
                  padding: const EdgeInsets.all(8.0).r,
                  child: CustomIconButton(
                    icon: const BackButtonIcon(),
                    onPressed: () => context.pop(),
                  ),
                )
              : null,
          flexibleSpace: FlexibleSpaceBar(
            background: Hero(
              tag:
                  '$tag${product.id}${product.categoryId}${product.restaurantId}${product.images.first}',
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      product.images.first,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 8.0).r,
          sliver: SliverList.list(children: [
            ListTile(
              title: Hero(
                tag:
                    '$tag${product.id}${product.categoryId}${product.restaurantId}${product.name}',
                child: Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    height: 0.9,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              trailing: Text.rich(
                TextSpan(
                  text: '${product.rate} ',
                  children: const [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.star_rounded,
                        color: AppColors.primary,
                        // size: 14,
                      ),
                    ),
                  ],
                ),
                style: TextStyle(
                  color: context.theme.iconTheme.color?.withOpacity(0.6),
                  fontSize: 18,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(
                '${(product.price - (product.price * product.sale)).toStringAsFixed(1)} EGP',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.primary.withOpacity(0.8),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: product.sale > 0
                  ? Text(
                      '${product.price} EGP',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.theme.iconTheme.color?.withOpacity(0.5),
                        fontSize: 16,
                        decoration: TextDecoration.lineThrough,
                        decorationColor:
                            context.theme.iconTheme.color?.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
              trailing: product.sale > 0
                  ? Text.rich(
                      TextSpan(
                        text: '${(product.sale * 100).toInt()}% ',
                        children: [
                          TextSpan(
                            text: 'Sale',
                            style: TextStyle(
                              color: context.theme.iconTheme.color
                                  ?.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                      ),
                    )
                  : null,
            ),
            const Divider(),
            ListTile(
              isThreeLine: true,
              subtitle: Hero(
                tag:
                    '${product.id}${product.categoryId}${product.restaurantId}${product.description}',
                child: Text(
                  product.description,
                  maxLines: null,
                  style: TextStyle(
                    color: context.theme.iconTheme.color?.withOpacity(0.8),
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ]),
        ),
        const SliverFillRemaining(),
      ],
    );
  }
}

class _ProductDetailsLandscape extends StatelessWidget {
  final Product product;
  final String tag;
  const _ProductDetailsLandscape({
    required this.product,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

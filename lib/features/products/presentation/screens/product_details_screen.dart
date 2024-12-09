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
import 'package:your_chef/features/products/presentation/widgets/add_to_cart_section.dart';
import 'package:your_chef/features/products/presentation/widgets/product_tile.dart';
import 'package:your_chef/features/products/presentation/widgets/restaurant_tile.dart';
import 'package:your_chef/features/wishlist/presentation/bloc/wishlist_bloc.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.tag,
  });

  final Product product;
  final String tag;

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
      bottomNavigationBar: AddToCartSection(
        inCart: true,
        count: 4,
        product: product,
      ),
    );
  }
}

class _ProductDetailsPortrait extends StatefulWidget {
  const _ProductDetailsPortrait({
    required this.product,
    required this.tag,
  });

  final Product product;
  final String tag;

  @override
  State<_ProductDetailsPortrait> createState() =>
      _ProductDetailsPortraitState();
}

class _ProductDetailsPortraitState extends State<_ProductDetailsPortrait> {
  final ScrollController _scrollController = ScrollController();
  bool _visible = false;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >= kToolbarHeight * 6) {
      if (_visible) return;
      setState(() {
        _visible = true;
      });
    } else {
      if (!_visible) return;
      setState(() {
        _visible = false;
      });
    }
  }

  void _toggleFavorite(BuildContext context) {
    if (AppDummies.foodsWishlist
        .where((food) => food.id == widget.product.id)
        .toList()
        .isEmpty) {
      context
          .read<WishlistBloc>()
          .add(AddFoodToWishlistWishlistEvent(widget.product));
    } else {
      context
          .read<WishlistBloc>()
          .add(RemoveFoodFromWishlistWishlistEvent(widget.product));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          pinned: true,
          titleSpacing: 0,
          // floating: true,
          expandedHeight: 260.h,
          title: AnimatedOpacity(
            opacity: _visible ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: ProductTile(
              product: widget.product,
            ),
          ),
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
                      .where((food) => food.id == widget.product.id)
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
                  .where((food) => food.id == widget.product.id)
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
                  '${widget.tag}${widget.product.id}${widget.product.images.first}',
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      widget.product.images.first,
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
            RestaurantTile(restaurant: widget.product.restaurant),
            ListTile(
              title: Hero(
                tag: '${widget.tag}${widget.product.id}}${widget.product.name}',
                child: Text(
                  widget.product.name,
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
                  text: '${widget.product.rate} ',
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
                '${(widget.product.price - (widget.product.price * widget.product.sale)).toStringAsFixed(1)} EGP',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.primary.withOpacity(0.8),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: widget.product.sale > 0
                  ? Text(
                      '${widget.product.price} EGP',
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
              trailing: widget.product.sale > 0
                  ? Text.rich(
                      TextSpan(
                        text: '${(widget.product.sale * 100).toInt()}% ',
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
                tag: '${widget.product.id}${widget.product.description}',
                child: Text(
                  widget.product.description,
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
  const _ProductDetailsLandscape({
    required this.product,
    required this.tag,
  });

  final Product product;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

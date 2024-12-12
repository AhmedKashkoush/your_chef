import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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
  final ValueNotifier<bool> _visible = ValueNotifier(false);
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >= (kToolbarHeight * 6).h) {
      if (_visible.value) return;

      _visible.value = true;
    } else {
      if (!_visible.value) return;

      _visible.value = false;
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
          title: ValueListenableBuilder(
              valueListenable: _visible,
              builder: (context, visible, _) {
                return AnimatedOpacity(
                  opacity: visible ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: ProductTile(
                    product: widget.product,
                  ),
                );
              }),
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
            background: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CarouselSlider.builder(
                  itemCount: widget.product.images.length,
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      _currentIndex.value = index;
                    },
                    viewportFraction: 1,
                    padEnds: false,
                    height: double.infinity,
                    autoPlay: widget.product.images.length > 1,
                    enableInfiniteScroll: widget.product.images.length > 1,
                    enlargeCenterPage: true,
                    autoPlayInterval: const Duration(seconds: 3),
                  ),
                  itemBuilder: (_, index, __) => Hero(
                    tag:
                        'food${widget.tag}${widget.product.id}${widget.product.images[index]}',
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            widget.product.images[index],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  child: ValueListenableBuilder(
                      valueListenable: _currentIndex,
                      builder: (context, index, _) {
                        return Container(
                          padding: const EdgeInsets.all(8).r,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(16).r,
                          ),
                          child: AnimatedSmoothIndicator(
                            count: widget.product.images.length,
                            activeIndex: index,
                            effect: const ScrollingDotsEffect(
                              dotWidth: 8,
                              dotHeight: 8,
                              activeDotColor: AppColors.primary,
                              dotColor: Colors.grey,
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 8.0).r,
          sliver: SliverList.list(
            children: [
              RestaurantTile(
                restaurant: widget.product.restaurant,
                tag: widget.tag,
              ),
              ListTile(
                title: Hero(
                  tag:
                      'food${widget.tag}${widget.product.id}${widget.product.name}',
                  child: Material(
                    type: MaterialType.transparency,
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
                title: Hero(
                  tag:
                      'food${widget.tag}${widget.product.id}${widget.product.price - (widget.product.price * widget.product.sale)}',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      '${(widget.product.price - (widget.product.price * widget.product.sale)).toStringAsFixed(1)} EGP',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                subtitle: widget.product.sale > 0
                    ? Text(
                        '${widget.product.price} EGP',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color:
                              context.theme.iconTheme.color?.withOpacity(0.5),
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
              ExpansionTile(
                maintainState: true,
                initiallyExpanded: true,
                shape: const RoundedRectangleBorder(
                  side: BorderSide.none,
                ),
                title: const Text(
                  'About meal',
                  style: TextStyle(
                    height: 0.9,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                childrenPadding: EdgeInsets.symmetric(horizontal: 16.w),
                children: [
                  Hero(
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
                ],
              ),
            ],
          ),
        ),
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

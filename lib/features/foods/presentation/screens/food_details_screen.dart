import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/number_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/core/widgets/buttons/custom_icon_button.dart';
import 'package:your_chef/core/widgets/buttons/secondary_button.dart';
import 'package:your_chef/core/widgets/layout/orientation_widget.dart';
import 'package:your_chef/core/widgets/rating/star_rating_widget.dart';
import 'package:your_chef/core/widgets/tiles/review_tile.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/orders/presentation/blocs/cart/add_remove/add_remove_cart_bloc.dart';
import 'package:your_chef/features/foods/presentation/widgets/food_details/add_to_cart_section.dart';
import 'package:your_chef/features/foods/presentation/widgets/food_details/food_tile.dart';
import 'package:your_chef/features/foods/presentation/widgets/food_details/restaurant_tile.dart';
import 'package:your_chef/common/blocs/wishlist/wishlist_bloc.dart';
import 'package:your_chef/locator.dart';

class FoodDetailsScreen extends StatelessWidget {
  const FoodDetailsScreen({
    super.key,
    required this.food,
    required this.tag,
  });

  final Food food;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<AddRemoveCartBloc>(),
      child: Scaffold(
        body: OrientationWidget(
          portrait: _FoodDetailsPortrait(
            food: food,
            tag: tag,
          ),
          landscape: _FoodDetailsLandscape(
            food: food,
            tag: tag,
          ),
        ),
        bottomNavigationBar: AddToCartSection(
          food: food,
        ),
      ),
    );
  }
}

class _FoodDetailsPortrait extends StatefulWidget {
  const _FoodDetailsPortrait({
    required this.food,
    required this.tag,
  });

  final Food food;
  final String tag;

  @override
  State<_FoodDetailsPortrait> createState() => _FoodDetailsPortraitState();
}

class _FoodDetailsPortraitState extends State<_FoodDetailsPortrait> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _visible = ValueNotifier(false);
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);

  String get _baseTag => 'food${widget.tag}${widget.food.id}';

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
        .where((food) => food.id == widget.food.id)
        .toList()
        .isEmpty) {
      context
          .read<WishlistBloc>()
          .add(AddFoodToWishlistWishlistEvent(widget.food));
    } else {
      context
          .read<WishlistBloc>()
          .add(RemoveFoodFromWishlistWishlistEvent(widget.food));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          pinned: true,
          surfaceTintColor: Colors.transparent,
          backgroundColor: context.theme.scaffoldBackgroundColor,
          titleSpacing: 0,
          // floating: true,
          expandedHeight: 260.h,
          title: ValueListenableBuilder(
              valueListenable: _visible,
              builder: (context, visible, _) {
                return AnimatedOpacity(
                  opacity: visible ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: FoodTile(
                    food: widget.food,
                  ),
                );
              }),
          actions: [
            BlocConsumer<WishlistBloc, WishlistState>(
                listener: (context, state) {
              if (state.status == RequestStatus.success) {
                if (AppDummies.foodsWishlist
                    .where((food) => food.id == widget.food.id)
                    .toList()
                    .isNotEmpty) {
                  AppMessages.showSuccessMessage(
                      context, AppStrings.foodAddedToYourWishlist.tr());
                } else {
                  AppMessages.showSuccessMessage(
                      context, AppStrings.foodRemovedFromYourWishlist.tr());
                }
              }
              if (state.status == RequestStatus.failure) {
                AppMessages.showErrorMessage(
                  context,
                  state.error,
                  state.errorType,
                );
              }
            }, builder: (context, state) {
              bool favorite = AppDummies.foodsWishlist
                  .where((food) => food.id == widget.food.id)
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
                  itemCount: widget.food.images.length,
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      _currentIndex.value = index;
                    },
                    viewportFraction: 1,
                    padEnds: false,
                    height: double.infinity,
                    autoPlay: widget.food.images.length > 1,
                    enableInfiniteScroll: widget.food.images.length > 1,
                    enlargeCenterPage: true,
                    autoPlayInterval: const Duration(seconds: 3),
                  ),
                  itemBuilder: (_, index, __) => Hero(
                    tag: '${_baseTag}image+$index',
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            widget.food.images[index],
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
                            count: widget.food.images.length,
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
                restaurant: widget.food.restaurant,
                tag: widget.tag,
              ),
              ListTile(
                title: Hero(
                  tag: '${_baseTag}name',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      widget.food.name,
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
                    children: [
                      if (widget.food.rate > 0) ...[
                        TextSpan(
                          text: '${widget.food.rate} ',
                        ),
                        WidgetSpan(
                          child: StarRatingWidget(
                            rate: widget.food.rate.toDouble(),
                            size: 18.sp,
                          ),
                        ),
                      ] else
                        TextSpan(text: AppStrings.noRatings.tr()),
                    ],
                    style: TextStyle(
                      color: context.theme.iconTheme.color?.withOpacity(0.6),
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
              // const Divider(),
              ListTile(
                title: Hero(
                  tag: '${_baseTag}price',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      '${(widget.food.price - (widget.food.price * widget.food.sale)).asThousands} ${AppStrings.egp.tr()}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                subtitle: widget.food.sale > 0
                    ? Text(
                        '${widget.food.price.asThousands} ${AppStrings.egp.tr()}',
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
                trailing: widget.food.sale > 0
                    ? Chip(
                        padding: const EdgeInsets.all(4).r,
                        backgroundColor: AppColors.primary,
                        side: BorderSide.none,
                        shape: const StadiumBorder(),
                        label: Text.rich(
                          TextSpan(
                            text: '${(widget.food.sale * 100).toInt()}% ',
                            children: [
                              TextSpan(
                                text: AppStrings.sale.tr(),
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      )
                    : null,
              ),

              ListTile(
                title: Hero(
                  tag: '${_baseTag}description',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      widget.food.description,
                      maxLines: null,
                      style: TextStyle(
                        color: context.theme.iconTheme.color?.withOpacity(0.8),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                trailing: SecondaryButton(
                  icon: HugeIcons.strokeRoundedStar,
                  onPressed: () {},
                  text: AppStrings.addReview.tr(),
                ),
              ),
              const Divider(),
              ListTile(
                title: Text(
                  AppStrings.otherReviews.tr(),
                  style: const TextStyle(
                    height: 0.9,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  final double rate = double.parse(
                      (Random().nextDouble() * 5).toStringAsFixed(1));
                  return ReviewTile(
                    image: 'https://picsum.photos/200/300',
                    username: 'User name',
                    review: 'user review' * 70,
                    rate: rate,
                  );
                },
                separatorBuilder: (_, index) => 8.height,
                itemCount: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FoodDetailsLandscape extends StatelessWidget {
  const _FoodDetailsLandscape({
    required this.food,
    required this.tag,
  });

  final Food food;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/widgets/buttons/custom_icon_button.dart';
import 'package:your_chef/core/widgets/separators/card_divider_widget.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';
import 'package:your_chef/features/restaurants/presentation/bloc/menu/get_restaurant_menu_bloc.dart';
import 'package:your_chef/features/restaurants/presentation/bloc/offers/get_restaurant_offers_bloc.dart';

import 'package:your_chef/features/restaurants/presentation/widgets/sections/restaurant_images_list_section.dart';
import 'package:your_chef/features/restaurants/presentation/widgets/sections/restaurant_info_section.dart';
import 'package:your_chef/features/restaurants/presentation/widgets/sections/restaurant_menu_list_section.dart';
import 'package:your_chef/features/restaurants/presentation/widgets/sections/restaurant_offers_section.dart';
import 'package:your_chef/features/restaurants/presentation/widgets/tiles/restaurant_about_tile.dart';
import 'package:your_chef/features/restaurants/presentation/widgets/tiles/restaurant_contact_tile.dart';
import 'package:your_chef/features/restaurants/presentation/widgets/tiles/restaurant_header_tile.dart';
import 'package:your_chef/features/restaurants/presentation/widgets/tiles/restaurant_location_tile.dart';
import 'package:your_chef/features/restaurants/presentation/widgets/tiles/restaurant_map_tile.dart';
import 'package:your_chef/locator.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  const RestaurantDetailsScreen({
    super.key,
    required this.restaurant,
    required this.tag,
  });

  final Restaurant restaurant;
  final String tag;

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _visible = ValueNotifier(false);

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >= (kToolbarHeight * 2.8).h) {
      if (_visible.value) return;

      _visible.value = true;
    } else {
      if (!_visible.value) return;

      _visible.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => locator<GetRestaurantOffersBloc>()
            ..add(
              GetRestaurantOffersEventStarted(
                RestaurantOptions(
                  restaurant: widget.restaurant,
                ),
              ),
            ),
        ),
        BlocProvider(
          create: (context) => locator<GetRestaurantMenuBloc>()
            ..add(
              GetRestaurantMenuEventStarted(
                RestaurantOptions(
                  restaurant: widget.restaurant,
                ),
              ),
            ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          titleSpacing: 0,
          leadingWidth: 56.w,
          leading: context.canPop()
              ? Padding(
                  padding: const EdgeInsets.all(8.0).r,
                  child: CustomIconButton(
                    icon: const BackButtonIcon(),
                    onPressed: () => context.pop(),
                  ),
                )
              : null,
          title: ValueListenableBuilder(
              valueListenable: _visible,
              builder: (context, visible, _) {
                return AnimatedOpacity(
                  opacity: visible ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: RestaurantHeaderTile(restaurant: widget.restaurant),
                );
              }),
        ),
        body: ListView(
          cacheExtent: 3000,
          padding: const EdgeInsets.symmetric(vertical: 16).r,
          controller: _scrollController,
          children: [
            RestaurantInfoSection(restaurant: widget.restaurant),
            16.height,
            const CardDividerWidget(),
            16.height,
            RestaurantLocationTile(
              restaurant: widget.restaurant,
            ),
            16.height,
            RestaurantMapTile(
              restaurant: widget.restaurant,
            ),
            16.height,
            const CardDividerWidget(),
            8.height,
            RestaurantContactTile(restaurant: widget.restaurant),
            8.height,
            const CardDividerWidget(),
            8.height,
            RestaurantAboutTile(restaurant: widget.restaurant),
            8.height,
            RestaurantImagesListSection(restaurant: widget.restaurant),
            RestaurantOffersSection(
              restaurant: widget.restaurant,
            ),
            RestaurantMenuListSection(
              tag: widget.tag,
              restaurant: widget.restaurant,
            ),
          ],
        ),
      ),
    );
  }
}

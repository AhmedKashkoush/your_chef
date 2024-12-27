import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/widgets/errors/custom_error_widget.dart';
import 'package:your_chef/core/widgets/loading/skeleton_loading_widget.dart';
import 'package:your_chef/core/widgets/separators/card_divider_widget.dart';
import 'package:your_chef/features/offers/domain/entities/offer.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';
import 'package:your_chef/features/restaurants/presentation/bloc/offers/get_restaurant_offers_bloc.dart';
import 'package:your_chef/core/widgets/items/restaurant_offer_item.dart';

class RestaurantOffersSection extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantOffersSection({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetRestaurantOffersBloc, GetRestaurantOffersState>(
      builder: (context, state) {
        if (state is GetRestaurantOffersInitialState ||
            (state is GetRestaurantOffersSuccessState &&
                state.offers.isEmpty)) {
          return const SizedBox.shrink();
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            16.height,
            const CardDividerWidget(),
            8.height,
            SkeletonLoadingWidget(
              loading: state is GetRestaurantOffersLoadingState,
              child: state is GetRestaurantOffersErrorState
                  ? CustomErrorWidget(
                      error: state.error,
                      onRetry: () =>
                          context.read<GetRestaurantOffersBloc>().add(
                                GetRestaurantOffersEventStarted(
                                  RestaurantOptions(
                                    restaurant: restaurant,
                                  ),
                                ),
                              ),
                    )
                  : _buildOffers(
                      loading: state is GetRestaurantOffersLoadingState,
                      offers: state is GetRestaurantOffersLoadingState
                          ? _loadingOffers
                          : state is GetRestaurantOffersSuccessState
                              ? state.offers
                              : [],
                    ),
            ),
          ],
        );
      },
    );
  }

  List<Offer> get _loadingOffers => [AppDummies.offers.first.toEntity()];
  Widget _buildOffers({required List<Offer> offers, required bool loading}) {
    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: offers.length,
          itemBuilder: (context, index, _) => RestaurantOfferItem(
            offer: offers[index],
          ),
          options: CarouselOptions(
            aspectRatio: 16 / 9,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: offers.length > 1,
            autoPlay: offers.length > 1,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          ),
        ),
        if (!loading)
          Align(
            alignment: AlignmentDirectional.center,
            child: Chip(
              padding: const EdgeInsets.all(4).r,
              side: BorderSide.none,
              backgroundColor: AppColors.primary,
              shape: const StadiumBorder(),
              label: Text(
                AppStrings.specialOffers,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

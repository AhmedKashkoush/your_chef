import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/features/home/domain/entities/offer.dart';
import 'package:your_chef/features/restaurants/presentation/widgets/items/restaurant_offer_item.dart';

class RestaurantOffersSection extends StatelessWidget {
  const RestaurantOffersSection({
    super.key,
    required this.offers,
  });
  final List<Offer> offers;

  @override
  Widget build(BuildContext context) {
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
        Align(
          alignment: AlignmentDirectional.center,
          child: Chip(
            padding: const EdgeInsets.all(4).r,
            side: BorderSide.none,
            backgroundColor: AppColors.primary,
            shape: const StadiumBorder(),
            label: Text(
              'Special offers',
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

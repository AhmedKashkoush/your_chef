import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/features/home/domain/entities/restaurant.dart';

class RestaurantsSection extends StatelessWidget {
  final List<Restaurant> restaurants;
  const RestaurantsSection({
    super.key,
    required this.restaurants,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: restaurants.length,
        separatorBuilder: (_, __) => 10.width,
        itemBuilder: (_, index) => Container(
          width: 140.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
      ),
    );
  }
}

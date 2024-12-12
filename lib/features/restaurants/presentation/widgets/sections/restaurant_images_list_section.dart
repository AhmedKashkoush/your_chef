import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/features/home/domain/entities/restaurant.dart';

class RestaurantImagesListSection extends StatelessWidget {
  const RestaurantImagesListSection({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 14).r,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, index) => 10.width,
        itemCount: restaurant.images.length,
        itemBuilder: (_, index) => Container(
          width: 300.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12).r,
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                restaurant.images[index],
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

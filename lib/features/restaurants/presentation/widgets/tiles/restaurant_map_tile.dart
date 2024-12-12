import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/features/home/domain/entities/restaurant.dart';

class RestaurantMapTile extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantMapTile({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160.h,
      color: Colors.white,
      child: const Icon(
        HugeIcons.strokeRoundedLocation01,
        color: Colors.red,
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/features/home/domain/entities/restaurant.dart';

class RestaurantTile extends StatelessWidget {
  const RestaurantTile({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0).r,
      child: ListTile(
        tileColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        leading: Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                restaurant.profileImage,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        trailing: TextButton(
          onPressed: () {},
          child: const Text(
            'Visit',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          restaurant.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            // color: context.theme.iconTheme.color?.withOpacity(0.6),
            color: Colors.white,
            fontWeight: FontWeight.bold,
            // fontSize: 18,
          ),
        ),
        subtitle: Text.rich(
          TextSpan(
            text: '${restaurant.rate} ',
            children: const [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(
                  Icons.star_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            // fontSize: 18,
          ),
        ),
      ),
    );
  }
}

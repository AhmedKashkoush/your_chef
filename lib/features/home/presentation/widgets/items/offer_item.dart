import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/features/home/domain/entities/offer.dart';

class OfferItem extends StatelessWidget {
  const OfferItem({
    super.key,
    required this.offer,
  });

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: Theme.of(context).iconTheme.color?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(
            offer.image,
          ),
        ),
      ),
    );
  }
}

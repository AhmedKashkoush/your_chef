import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/extensions/media_query_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/features/offers/domain/entities/offer.dart';

class OfferItem extends StatelessWidget {
  const OfferItem({
    super.key,
    required this.offer,
  });

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: context.isLandscape ? 9 / 3 : 16 / 9,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: context.theme.iconTheme.color?.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(
              offer.image,
            ),
          ),
        ),
      ),
    );
  }
}

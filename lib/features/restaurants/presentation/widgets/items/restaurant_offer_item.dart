import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:your_chef/features/home/domain/entities/offer.dart';

class RestaurantOfferItem extends StatelessWidget {
  const RestaurantOfferItem({
    super.key,
    required this.offer,
  });

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:your_chef/core/extensions/media_query_extension.dart';
import 'package:your_chef/features/offers/domain/entities/offer.dart';
import 'package:your_chef/features/home/presentation/widgets/items/offer_item.dart';

class OffersSection extends StatelessWidget {
  final List<Offer> offers;
  final bool loading;
  const OffersSection({
    super.key,
    required this.offers,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: RepaintBoundary(
        child: CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1,
            aspectRatio: context.isLandscape ? 9 / 3 : 16 / 9,
            autoPlay: !loading,
            enlargeCenterPage: true,
          ),
          items: offers
              .map(
                (offer) => OfferItem(offer: offer),
              )
              .toList(),
        ),
      ),
    );
  }
}

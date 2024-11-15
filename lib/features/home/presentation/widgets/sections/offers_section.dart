import 'package:flutter/material.dart';
import 'package:your_chef/features/home/domain/entities/offer.dart';
import 'package:your_chef/features/home/presentation/widgets/items/offer_item.dart';

class OffersSection extends StatelessWidget {
  final List<Offer> offers;
  const OffersSection({
    super.key,
    required this.offers,
  });

  @override
  Widget build(BuildContext context) {
    return OfferItem(offer: offers.first);
  }
}

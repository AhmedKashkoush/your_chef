import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/features/home/domain/entities/offer.dart';

class OffersSection extends StatelessWidget {
  final List<Offer> offers;
  const OffersSection({
    super.key,
    required this.offers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
    );
  }
}

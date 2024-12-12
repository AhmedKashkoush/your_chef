import 'package:flutter/material.dart';
import 'package:your_chef/core/constants/colors.dart';

class StarRatingWidget extends StatelessWidget {
  const StarRatingWidget({
    super.key,
    required this.rate,
    this.size = 16,
    this.color,
    this.rateColor,
  });

  final Color? color, rateColor;
  final double rate, size;

  Color get _rateColor => AppColors.primary;

  Color get _color => Colors.grey.shade300;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) {
          if (rate - 1 >= index) {
            return Icon(
              Icons.star_rounded,
              color: rateColor ?? _rateColor,
              size: size,
            );
          }
          double remaining = (rate - 1 / rate.floor() - 1).abs();
          if (remaining > 0 && index == (rate.ceil() - 1).abs()) {
            return Icon(
              Icons.star_half_rounded,
              color: rateColor ?? _rateColor,
              size: size,
            );
          }

          return Icon(
            Icons.star_outline_rounded,
            color: color ?? _color,
            size: size,
          );
        },
      ),
    );
  }
}

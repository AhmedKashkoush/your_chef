import 'package:flutter/material.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/widgets/rating/star_rating_widget.dart';

class ReviewTile extends StatelessWidget {
  const ReviewTile({
    super.key,
    required this.rate,
  });

  final double rate;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'User name',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          rate > 0
              ? StarRatingWidget(
                  rate: rate,
                )
              : const Text(AppStrings.noRatings)
        ],
      ),
      isThreeLine: true,
      subtitle: Text(
        'user review' * 70,
        style: TextStyle(
          color: context.theme.iconTheme.color?.withOpacity(0.8),
          fontSize: 14,
        ),
      ),
    );
  }
}

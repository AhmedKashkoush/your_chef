import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/widgets/avatars/user_avatar.dart';
import 'package:your_chef/core/widgets/rating/star_rating_widget.dart';

class ReviewTile extends StatelessWidget {
  final String username, image, review;
  final double rate;
  const ReviewTile({
    super.key,
    required this.username,
    required this.image,
    required this.review,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserAvatar(
        url: image,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            username,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          rate > 0
              ? StarRatingWidget(
                  rate: rate,
                )
              : Text(AppStrings.noRatings.tr())
        ],
      ),
      isThreeLine: true,
      subtitle: review.isNotEmpty
          ? Text(
              review,
              style: TextStyle(
                color: context.theme.iconTheme.color?.withOpacity(0.8),
                fontSize: 14,
              ),
            )
          : null,
    );
  }
}

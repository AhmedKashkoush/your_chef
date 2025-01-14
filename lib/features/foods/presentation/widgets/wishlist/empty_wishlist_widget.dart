import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/widgets/buttons/primary_button.dart';

class EmptyWishlistWidget extends StatelessWidget {
  const EmptyWishlistWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0).r,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              HugeIcons.strokeRoundedHeartRemove,
              size: 100.r,
              color: context.theme.iconTheme.color?.withOpacity(0.3),
            ),
            Text(
              AppStrings.wishlistEmptyMessage.tr(),
              textAlign: TextAlign.center,
              style: context.theme.textTheme.titleLarge?.copyWith(
                color: context.theme.iconTheme.color?.withOpacity(0.3),
              ),
            ),
            30.height,
            PrimaryButton(
              text: AppStrings.exploreFoods.tr(),
              icon: Icons.explore_outlined,
              onPressed: () {
                context.pushNamed(AppRoutes.foods);
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  const SectionHeader({
    super.key,
    required this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              color: context.theme.iconTheme.color?.withOpacity(0.3),
              fontWeight: FontWeight.bold,
            ),
          ),
          if (onPressed != null)
            TextButton(
              onPressed: onPressed,
              child: const Text(
                AppStrings.viewAll,
                style: TextStyle(color: AppColors.secondary),
              ),
            ),
        ],
      ),
    );
  }
}

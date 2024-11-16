import 'package:flutter/material.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';

class LogoText extends StatelessWidget {
  const LogoText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.appName,
      style: context.theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        fontFamily: 'Vivaldii',
      ),
    );
  }
}

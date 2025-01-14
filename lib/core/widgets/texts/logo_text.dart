import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';

class LogoText extends StatelessWidget {
  final bool isHero;
  const LogoText({
    super.key,
    this.isHero = true,
  });

  @override
  Widget build(BuildContext context) {
    return isHero
        ? Hero(
            tag: 'logo-text',
            child: _buildText(context),
          )
        : _buildText(context);
  }

  Text _buildText(BuildContext context) {
    return Text(
      AppStrings.appName.tr(),
      style: context.theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        fontFamily: 'Vivaldii',
      ),
    );
  }
}

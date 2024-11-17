import 'package:flutter/material.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';

class CustomIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final Color? color;
  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        foregroundColor: color ?? AppColors.primary,
        backgroundColor: context.theme.scaffoldBackgroundColor,
      ),
      icon: icon,
    );
  }
}

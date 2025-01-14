import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:your_chef/core/constants/strings.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SkipButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        AppStrings.skip.tr(),
        style: const TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}

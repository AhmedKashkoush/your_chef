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
      child: const Text(
        AppStrings.skip,
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}

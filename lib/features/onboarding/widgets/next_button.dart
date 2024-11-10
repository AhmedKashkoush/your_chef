import 'package:flutter/material.dart';
import 'package:your_chef/core/constants/colors.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onPressed;
  const NextButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onPressed,
      icon: const Icon(Icons.arrow_forward),
      style: IconButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

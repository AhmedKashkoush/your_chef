import 'package:flutter/material.dart';

class PreviousButton extends StatelessWidget {
  final VoidCallback onPressed;
  const PreviousButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      onPressed: onPressed,
      icon: const Icon(Icons.arrow_back),
      style: IconButton.styleFrom(
        shape: const CircleBorder(
          side: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            color: Theme.of(context).iconTheme.color?.withOpacity(0.3),
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onPressed != null)
          TextButton(
            onPressed: () {},
            child: const Text('View All'),
          ),
      ],
    );
  }
}

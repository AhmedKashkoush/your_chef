import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/constants/colors.dart';

class CartButton extends StatelessWidget {
  final IconData icon;
  const CartButton({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Badge.count(
      count: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      padding: const EdgeInsets.all(2).r,
      textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

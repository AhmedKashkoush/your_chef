import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/core/constants/colors.dart';

class PhotoAvatar extends StatelessWidget {
  const PhotoAvatar({
    super.key,
    this.image,
    this.onTap,
    this.radius = 120,
  });

  final File? image;
  final VoidCallback? onTap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        foregroundImage: image != null ? FileImage(image!) : null,
        radius: radius.r,
        child: Icon(
          HugeIcons.strokeRoundedCamera02,
          size: (radius - 40).r,
          color: AppColors.primary.withOpacity(0.5),
        ),
      ),
    );
  }
}

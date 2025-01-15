import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/core/constants/colors.dart';

class UserAvatar extends StatelessWidget {
  final String url;
  final double? radius;
  final VoidCallback? onTap;
  final File? uploadedImage;
  const UserAvatar({
    super.key,
    this.radius,
    required this.url,
    this.onTap,
    this.uploadedImage,
  });

  double get _radius => 64.r;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: radius ?? _radius,
        height: radius ?? _radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withOpacity(0.6),
          image: uploadedImage == null && url.isEmpty
              ? null
              : DecorationImage(
                  image: uploadedImage == null
                      ? CachedNetworkImageProvider(url)
                      : FileImage(uploadedImage!),
                  fit: BoxFit.cover,
                ),
        ),
        child: uploadedImage == null && url.isEmpty
            ? FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(2.0).r,
                  child: const Icon(
                    HugeIcons.strokeRoundedUser,
                    color: Colors.white70,
                    // size: (radius ?? _radius) * 1.5.r,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

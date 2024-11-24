import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius ?? 24.r,
        foregroundImage: uploadedImage == null
            ? CachedNetworkImageProvider(url)
            : FileImage(uploadedImage!),
        child: const Icon(HugeIcons.strokeRoundedUser),
      ),
    );
  }
}

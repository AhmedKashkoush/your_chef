import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class UserAvatar extends StatelessWidget {
  final String url;
  final double? radius;
  const UserAvatar({
    super.key,
    this.radius,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 24.r,
      foregroundImage: CachedNetworkImageProvider(url),
      child: const Icon(HugeIcons.strokeRoundedUser),
    );
  }
}

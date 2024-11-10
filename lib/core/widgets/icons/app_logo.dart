import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/images.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool isHero;
  const AppLogo({
    super.key,
    this.size = 64,
    this.isHero = false,
  });

  @override
  Widget build(BuildContext context) {
    return isHero
        ? Hero(
            tag: 'logo',
            child: _buildAvatar(),
          )
        : _buildAvatar();
  }

  Widget _buildAvatar() => CircleAvatar(
        radius: size.r,
        backgroundImage: const AssetImage(AppImages.logo),
      );
}

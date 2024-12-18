import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';

class SkeletonLoadingWidget extends StatelessWidget {
  final Widget child;
  final bool loading;
  const SkeletonLoadingWidget({
    super.key,
    required this.child,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.theme.colorScheme.brightness == Brightness.dark;
    return Skeletonizer(
      enabled: loading,
      containersColor: Colors.grey.shade100.withOpacity(isDark ? 0.1 : 0.5),
      enableSwitchAnimation: true,
      child: child,
    );
  }
}

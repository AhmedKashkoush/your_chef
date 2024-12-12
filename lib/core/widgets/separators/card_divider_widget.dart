import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';

class CardDividerWidget extends StatelessWidget {
  const CardDividerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 8.h,
      color: context.theme.colorScheme.surface,
    );
  }
}

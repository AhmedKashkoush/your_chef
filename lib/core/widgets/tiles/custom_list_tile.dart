import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';

class CustomListTile extends StatelessWidget {
  final void Function()? onTap;
  final Widget? leading, trailing, title, subtitle;
  final EdgeInsetsGeometry? contentPadding;
  final double? horizontalTitleGap;
  const CustomListTile({
    super.key,
    this.onTap,
    this.leading,
    this.trailing,
    this.title,
    this.subtitle,
    this.contentPadding,
    this.horizontalTitleGap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        onTap: onTap,
        tileColor: context.theme.iconTheme.color?.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14).r,
        ),
        leading: leading,
        // minLeadingWidth: 48,
        title: title,
        subtitle: subtitle,
        contentPadding: contentPadding,
        horizontalTitleGap: horizontalTitleGap,
        trailing: trailing,
      ),
    );
  }
}

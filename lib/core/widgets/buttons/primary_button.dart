import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/extensions/space_extension.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.onPressed,
    required this.text,
    this.loading = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.count = 0,
    this.fontSize,
    this.padding,
  });

  final int count;
  final IconData? icon;
  final bool loading;
  final VoidCallback? onPressed;
  final String text;
  final Color? backgroundColor, textColor;
  final double? fontSize;
  final EdgeInsets? padding;

  Widget _buildText() {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: textColor ?? Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14).r,
        ),
      ),
      child: loading
          ? const SizedBox(
              height: 30,
              width: 30,
              child: FittedBox(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          : Padding(
              padding: padding ?? EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Flexible(
                      child: Icon(
                        icon,
                        color: Colors.white,
                      ),
                    ),
                    if (text.isNotEmpty) Flexible(child: 4.width),
                  ],
                  if (text.isNotEmpty && icon != null)
                    Flexible(
                      flex: 3,
                      child: _buildText(),
                    )
                  else
                    _buildText(),
                  if (count > 0) ...[
                    4.width,
                    Container(
                      padding: const EdgeInsets.all(6).r,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Text(
                        count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
    );
  }
}

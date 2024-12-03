import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/extensions/space_extension.dart';

class SecondaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool loading;
  final IconData? icon;

  const SecondaryButton({
    super.key,
    this.onPressed,
    required this.text,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14).r,
          side: const BorderSide(
            color: AppColors.primary,
          ),
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
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Flexible(
                    child: Icon(
                      icon,
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
              ],
            ),
    );
  }

  Text _buildText() {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

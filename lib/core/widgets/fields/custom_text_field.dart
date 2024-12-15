import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final Widget? prefixIcon, suffixIcon;
  final bool obscureText, enabled, readOnly, enableInteractiveSelection;
  final String? hintText, labelText;
  final String obscuringCharacter;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextStyle? hintStyle, labelStyle;
  final Color? prefixIconColor, suffixIconColor;
  final int? minLines, maxLines;

  const CustomTextField({
    super.key,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.hintText,
    this.labelText,
    this.obscuringCharacter = '•',
    this.controller,
    this.inputFormatters,
    this.enabled = true,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.hintStyle,
    this.labelStyle,
    this.prefixIconColor,
    this.suffixIconColor,
    this.textInputAction,
    this.onFieldSubmitted,
    this.enableInteractiveSelection = true,
    this.minLines,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      readOnly: readOnly,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      enabled: enabled,
      enableInteractiveSelection: enableInteractiveSelection,
      minLines: minLines,
      maxLines: maxLines,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        isDense: true,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        prefixIconColor: prefixIconColor,
        suffixIconColor: suffixIconColor,
        hintText: hintText,
        hintStyle: hintStyle,
        labelText: labelText,
        labelStyle: labelStyle,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.r),
        ),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.3),
      ),
    );
  }
}

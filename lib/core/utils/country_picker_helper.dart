import 'package:country_flags/country_flags.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/core/constants/strings.dart';

final class CountryPickerHelper {
  const CountryPickerHelper._();

  static void showPicker(
    BuildContext context, {
    required void Function(Country country) onSelect,
  }) =>
      showCountryPicker(
        context: context,
        onSelect: onSelect,
        showPhoneCode: true,
        exclude: ['IL'],
        customFlagBuilder: (Country country) => CountryFlag.fromCountryCode(
          country.countryCode,
          // width: 32.w,
          // height: 32.h,
          shape: const Circle(),
        ),
        useSafeArea: true,
        countryListTheme: CountryListThemeData(
          borderRadius: BorderRadius.circular(10.r),
          inputDecoration: InputDecoration(
            isDense: true,
            prefixIcon: const Icon(HugeIcons.strokeRoundedSearch01),
            // suffixIcon: suffixIcon,
            // prefixIconColor: prefixIconColor,
            // suffixIconColor: suffixIconColor,
            hintText: AppStrings.search.tr(),
            // hintStyle: hintStyle,
            // labelText: labelText,
            // labelStyle: labelStyle,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.r),
            ),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.3),
          ),
        ),
      );
}

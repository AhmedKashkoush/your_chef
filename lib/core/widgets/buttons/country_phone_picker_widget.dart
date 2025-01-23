import 'package:country_flags/country_flags.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/utils/country_picker_helper.dart';

class CountryPhonePickerWidget extends StatelessWidget {
  final Country country;
  final void Function(Country)? onSelect;
  const CountryPhonePickerWidget({
    super.key,
    required this.country,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CountryPickerHelper.showPicker(
          context,
          onSelect: onSelect ?? (_) {},
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CountryFlag.fromCountryCode(
            country.countryCode,
            width: 32.w,
            height: 32.h,
            shape: const Circle(),
          ),
          5.width,
          Text(
            "+${country.phoneCode}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}

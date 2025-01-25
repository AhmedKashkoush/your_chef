import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/enums/gender.dart';

class GenderTile extends StatelessWidget {
  final void Function(Gender) onSelect;
  final Gender value, selected;
  final bool enabled;
  const GenderTile({
    super.key,
    required this.onSelect,
    required this.value,
    required this.selected,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        enabled: enabled,
        selected: value == selected,
        selectedTileColor: AppColors.primary,
        selectedColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10).r,
        ),
        // titleTextStyle: TextStyle(
        //   fontWeight: FontWeight.bold,
        //   fontSize: 18.sp,
        // ),
        onTap: () => onSelect(value),
        leading: Icon(
          value == Gender.male ? Icons.male : Icons.female,
          size: 32.r,
        ),
        title: Text(value.name.tr()),
      ),
    );
  }
}

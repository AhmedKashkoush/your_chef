import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/widgets/tiles/custom_list_tile.dart';

class ChoosePhotoSourceSheet extends StatelessWidget {
  final VoidCallback onCameraSelect, onGallerySelect;
  const ChoosePhotoSourceSheet({
    super.key,
    required this.onCameraSelect,
    required this.onGallerySelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0).r,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomListTile(
            onTap: onCameraSelect,
            leading: const Icon(
              HugeIcons.strokeRoundedCamera02,
            ),
            title: Text(AppStrings.camera.tr()),
          ),
          16.height,
          CustomListTile(
            onTap: onGallerySelect,
            leading: const Icon(
              HugeIcons.strokeRoundedImage02,
            ),
            title: Text(AppStrings.gallery.tr()),
          ),
        ],
      ),
    );
  }
}

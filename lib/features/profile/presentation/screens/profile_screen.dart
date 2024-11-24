import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/utils/user_helper.dart';
import 'package:your_chef/core/widgets/avatars/user_avatar.dart';
import 'package:your_chef/core/widgets/bottom_sheets/choose_photo_source_sheet.dart';
import 'package:your_chef/core/widgets/fields/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  final String profileTag;
  const ProfileScreen({
    super.key,
    required this.profileTag,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController,
      _emailController,
      _phoneController,
      _addressController;

  File? _image;

  Future<bool> _checkPermissions() async {
    const String cameraMessage =
        'Please give permission to access the camera from app settings';
    const String galleryMessage =
        'Please give permission to access the gallery from app settings';
    PermissionStatus status = await Permission.camera.request();
    if (status == PermissionStatus.permanentlyDenied) {
      if (!mounted) return false;
      AppMessages.showErrorMessage(context, cameraMessage);
      return false;
    }
    if (status == PermissionStatus.denied) {
      status = await Permission.camera.request();
      if (status == PermissionStatus.denied) {
        if (!mounted) return false;
        AppMessages.showErrorMessage(context, cameraMessage);
        return false;
      }
    }
    status = await Permission.photos.request();
    if (status == PermissionStatus.permanentlyDenied) {
      if (!mounted) return false;
      AppMessages.showErrorMessage(context, galleryMessage);
      return false;
    }
    if (status == PermissionStatus.denied) {
      status = await Permission.camera.request();
      if (status == PermissionStatus.denied) {
        if (!mounted) return false;
        AppMessages.showErrorMessage(context, galleryMessage);
        return false;
      }
    }
    return true;
  }

  void _pickImage(ImageSource source) async {
    if (!await _checkPermissions()) return;
    final XFile? image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    setState(() {
      _image = File(image.path);
    });
  }

  void _showPhotoSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => ChoosePhotoSourceSheet(
        onCameraSelect: () {
          _pickImage(ImageSource.camera);
          context.pop();
        },
        onGallerySelect: () {
          _pickImage(ImageSource.gallery);
          context.pop();
        },
      ),
    );
  }

  @override
  void initState() {
    _nameController = TextEditingController(text: UserHelper.user?.name);
    _emailController = TextEditingController(text: UserHelper.user?.email);
    _phoneController = TextEditingController(text: UserHelper.user?.phone);
    _addressController = TextEditingController(text: UserHelper.user?.address);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Hero(
                    tag: widget.profileTag,
                    child: UserAvatar(
                      url: UserHelper.user!.image,
                      radius: 72.r,
                      uploadedImage: _image,
                    ),
                  ),
                  PositionedDirectional(
                    end: 0,
                    bottom: 0,
                    child: IconButton.filled(
                      onPressed: () => _showPhotoSourceSheet(context),
                      icon: const Icon(
                        HugeIcons.strokeRoundedEdit02,
                      ),
                    ),
                  )
                ],
              ),
            ),
            32.height,
            const Text(
              AppStrings.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            8.height,
            CustomTextField(
              readOnly: true,
              hintText: AppStrings.enterYourName,
              prefixIcon: const Icon(HugeIcons.strokeRoundedUser),
              controller: _nameController,
              enableInteractiveSelection: false,
            ),
            16.height,
            const Text(
              AppStrings.email,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            8.height,
            CustomTextField(
              readOnly: true,
              hintText: AppStrings.enterYourEmail,
              prefixIcon: const Icon(HugeIcons.strokeRoundedMail01),
              controller: _emailController,
              enableInteractiveSelection: false,
            ),
            16.height,
            const Text(
              AppStrings.phone,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            8.height,
            CustomTextField(
              readOnly: true,
              hintText: AppStrings.enterYourPhone,
              prefixIcon: const Icon(HugeIcons.strokeRoundedCall),
              controller: _phoneController,
              enableInteractiveSelection: false,
            ),
            16.height,
            const Text(
              AppStrings.address,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            8.height,
            CustomTextField(
              readOnly: true,
              hintText: AppStrings.enterYourAddress,
              prefixIcon: const Icon(HugeIcons.strokeRoundedLocation01),
              controller: _addressController,
              maxLines: 3,
              enableInteractiveSelection: false,
            ),
          ],
        ),
      ),
    );
  }
}

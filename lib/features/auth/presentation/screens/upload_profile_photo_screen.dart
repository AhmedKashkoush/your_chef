import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/utils/permission_helper.dart';
import 'package:your_chef/core/widgets/buttons/custom_icon_button.dart';
import 'package:your_chef/core/widgets/buttons/primary_button.dart';
import 'package:your_chef/core/widgets/layout/orientation_widget.dart';
import 'package:your_chef/features/auth/presentation/bloc/upload_profile_photo/upload_profile_photo_bloc.dart';
import 'package:your_chef/core/widgets/bottom_sheets/choose_photo_source_sheet.dart';
import 'package:your_chef/features/auth/presentation/widgets/photo_avatar.dart';
import 'package:your_chef/locator.dart';

class UploadProfilePhotoScreen extends StatefulWidget {
  final String uid;
  const UploadProfilePhotoScreen({
    super.key,
    required this.uid,
  });

  @override
  State<UploadProfilePhotoScreen> createState() =>
      _UploadProfilePhotoScreenState();
}

class _UploadProfilePhotoScreenState extends State<UploadProfilePhotoScreen> {
  File? _image;

  Future<bool> _checkPermissions(Permission permission) async {
    if (permission == Permission.camera) {
      return await PermissionHelper.requestPermission(Permission.camera,
          onError: () {
        if (!mounted) return;
        AppMessages.showErrorMessage(
          context,
          AppStrings.cameraPermissionMessage.tr(),
        );
      });
    }

    if (permission == Permission.photos) {
      return await PermissionHelper.requestPermission(Permission.photos,
          onError: () {
        if (!mounted) return;
        AppMessages.showErrorMessage(
          context,
          AppStrings.galleryPermissionMessage.tr(),
        );
      });
    }
    // PermissionStatus status = await Permission.camera.request();
    // if (status == PermissionStatus.permanentlyDenied) {
    //   if (!mounted) return false;
    //   AppMessages.showErrorMessage(context, cameraMessage);
    //   return false;
    // }
    // if (status == PermissionStatus.denied) {
    //   status = await Permission.camera.request();
    //   if (status == PermissionStatus.denied) {
    //     if (!mounted) return false;
    //     AppMessages.showErrorMessage(context, cameraMessage);
    //     return false;
    //   }
    // }

    // status = await Permission.photos.request();
    // if (status == PermissionStatus.permanentlyDenied) {
    //   if (!mounted) return false;
    //   AppMessages.showErrorMessage(context, galleryMessage);
    //   return false;
    // }
    // if (status == PermissionStatus.denied) {
    //   status = await Permission.camera.request();
    //   if (status == PermissionStatus.denied) {
    //     if (!mounted) return false;
    //     AppMessages.showErrorMessage(context, galleryMessage);
    //     return false;
    //   }
    // }
    return true;
  }

  void _pickImage(ImageSource source) async {
    final permission =
        source == ImageSource.camera ? Permission.camera : Permission.photos;
    if (!await _checkPermissions(permission)) return;
    final XFile? image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    setState(() {
      _image = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<UploadProfilePhotoBloc>(),
      child: BlocConsumer<UploadProfilePhotoBloc, UploadProfilePhotoState>(
        listener: (context, state) {
          if (state is UploadProfilePhotoErrorState) {
            AppMessages.showErrorMessage(context, state.message, state.type);
          }

          if (state is UploadProfilePhotoSuccessState) {
            context.pop();
          }
        },
        builder: (context, state) => Scaffold(
            body: OrientationWidget(
          portrait: _UploadProfilePhotoPortrait(
            onAvatarTap: () => _showPhotoSourceSheet(context, state),
            onSubmit: () => _submit(context),
            loading: state is UploadProfilePhotoLoadingState,
            image: _image,
          ),
          landscape: _UploadProfilePhotoLandscape(
            onAvatarTap: () => _showPhotoSourceSheet(context, state),
            onSubmit: () => _submit(context),
            loading: state is UploadProfilePhotoLoadingState,
            image: _image,
          ),
        )),
      ),
    );
  }

  void _showPhotoSourceSheet(
      BuildContext context, UploadProfilePhotoState state) {
    if (state is UploadProfilePhotoLoadingState) return;
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

  void _submit(BuildContext context) {
    if (_image == null) {
      context.pop();
      return;
    }
    final UploadProfileOptions options = UploadProfileOptions(
      photo: _image!,
      uid: widget.uid,
    );
    context
        .read<UploadProfilePhotoBloc>()
        .add(UploadProfilePhotoSubmitEvent(options));
  }
}

class _UploadProfilePhotoPortrait extends StatelessWidget {
  final VoidCallback onAvatarTap, onSubmit;
  final File? image;
  final bool loading;
  const _UploadProfilePhotoPortrait({
    required this.onAvatarTap,
    this.image,
    required this.onSubmit,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0).r,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: CustomIconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
            ),
            const Spacer(),
            Text(
              AppStrings.uploadProfileTitle.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AppStrings.uploadProfileBody.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: context.theme.iconTheme.color?.withOpacity(0.4),
              ),
            ),
            Flexible(child: 40.height),
            PhotoAvatar(
              onTap: onAvatarTap,
              image: image,
            ),
            const Spacer(
              flex: 3,
            ),
            PrimaryButton(
              onPressed: onSubmit,
              loading: loading,
              icon: image == null ? null : HugeIcons.strokeRoundedUpload02,
              text:
                  image == null ? AppStrings.skip.tr() : AppStrings.upload.tr(),
            ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadProfilePhotoLandscape extends StatelessWidget {
  final VoidCallback onAvatarTap, onSubmit;
  final File? image;
  final bool loading;
  const _UploadProfilePhotoLandscape({
    required this.onAvatarTap,
    this.image,
    required this.onSubmit,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0).r,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: CustomIconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: PhotoAvatar(
                      onTap: onAvatarTap,
                      image: image,
                      radius: 220,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0).r,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            AppStrings.uploadProfileTitle.tr(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            AppStrings.uploadProfileBody.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: context.theme.iconTheme.color
                                  ?.withOpacity(0.4),
                            ),
                          ),
                          // Flexible(child: 40.height),
                          const Spacer(
                            flex: 3,
                          ),
                          PrimaryButton(
                            onPressed: onSubmit,
                            loading: loading,
                            icon: image == null
                                ? null
                                : HugeIcons.strokeRoundedUpload02,
                            text: image == null
                                ? AppStrings.skip.tr()
                                : AppStrings.upload.tr(),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

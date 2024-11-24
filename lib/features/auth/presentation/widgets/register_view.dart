import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/widgets/buttons/primary_button.dart';
import 'package:your_chef/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:your_chef/features/auth/presentation/screens/upload_profile_photo_screen.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/fields/custom_text_field.dart';

class RegisterView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fNameController,
      lNameController,
      phoneController,
      addressController,
      emailController,
      passwordController,
      confirmController;
  final ValueNotifier<bool> passwordVisibility, confirmVisibility;
  final TabController tabController;
  const RegisterView({
    super.key,
    required this.fNameController,
    required this.lNameController,
    required this.phoneController,
    required this.addressController,
    required this.emailController,
    required this.passwordController,
    required this.confirmController,
    required this.passwordVisibility,
    required this.confirmVisibility,
    required this.tabController,
    required this.formKey,
  });

  void _clearControllers() {
    fNameController.clear();
    lNameController.clear();
    phoneController.clear();
    addressController.clear();
    emailController.clear();
    passwordController.clear();
    confirmController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) async {
        if (state is RegisterErrorState) {
          AppMessages.showErrorMessage(context, state.message, state.type);
        }

        if (state is RegisterSuccessState) {
          await _showProfileUploadScreen(context, state.uid);
          if (!context.mounted) return;
          tabController.animateTo(0);
          _clearControllers();
          AppMessages.showSuccessMessage(context, 'Account Created');
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40).r,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      keyboardType: TextInputType.name,
                      controller: fNameController,
                      validator: _validateName,
                      enabled: state is! RegisterLoadingState,
                      hintText: AppStrings.fName,
                      prefixIcon: const Icon(HugeIcons.strokeRoundedUser),
                    ),
                  ),
                  10.width,
                  Expanded(
                    child: CustomTextField(
                      keyboardType: TextInputType.name,
                      controller: lNameController,
                      validator: _validateName,
                      enabled: state is! RegisterLoadingState,
                      hintText: AppStrings.lName,
                      prefixIcon: const Icon(HugeIcons.strokeRoundedUser),
                    ),
                  ),
                ],
              ),
              10.height,
              CustomTextField(
                keyboardType: TextInputType.phone,
                controller: phoneController,
                validator: _validatePhone,
                enabled: state is! RegisterLoadingState,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(11),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                hintText: AppStrings.phone,
                prefixIcon: const Icon(HugeIcons.strokeRoundedCall),
              ),
              10.height,
              CustomTextField(
                keyboardType: TextInputType.streetAddress,
                controller: addressController,
                validator: _validateAddress,
                enabled: state is! RegisterLoadingState,
                hintText: AppStrings.address,
                prefixIcon: const Icon(HugeIcons.strokeRoundedLocation01),
              ),
              10.height,
              CustomTextField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                validator: _validateEmail,
                enabled: state is! RegisterLoadingState,
                hintText: AppStrings.email,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                prefixIcon: const Icon(HugeIcons.strokeRoundedMail01),
              ),
              10.height,
              ValueListenableBuilder(
                  valueListenable: passwordVisibility,
                  builder: (_, visible, __) {
                    return CustomTextField(
                      hintText: AppStrings.password,
                      enabled: state is! RegisterLoadingState,
                      controller: passwordController,
                      validator: _validatePassword,
                      obscureText: !visible,
                      obscuringCharacter: '*',
                      prefixIcon:
                          const Icon(HugeIcons.strokeRoundedLockPassword),
                      suffixIcon: IconButton(
                        onPressed: _toggleVisibility,
                        icon: visible
                            ? const Icon(HugeIcons.strokeRoundedViewOff)
                            : const Icon(HugeIcons.strokeRoundedEye),
                      ),
                    );
                  }),
              10.height,
              ValueListenableBuilder(
                  valueListenable: confirmVisibility,
                  builder: (_, visible, __) {
                    return CustomTextField(
                      hintText: AppStrings.confirmPassword,
                      enabled: state is! RegisterLoadingState,
                      controller: confirmController,
                      validator: _validateConfirm,
                      obscureText: !visible,
                      obscuringCharacter: '*',
                      prefixIcon:
                          const Icon(HugeIcons.strokeRoundedLockPassword),
                      suffixIcon: IconButton(
                        onPressed: _toggleConfirmVisibility,
                        icon: visible
                            ? const Icon(HugeIcons.strokeRoundedViewOff)
                            : const Icon(HugeIcons.strokeRoundedEye),
                      ),
                    );
                  }),
              20.height,
              PrimaryButton(
                onPressed: () => _register(context),
                loading: state is RegisterLoadingState,
                text: AppStrings.register,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showProfileUploadScreen(BuildContext context, String uid) {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => UploadProfilePhotoScreen(
        uid: uid,
      ),
    );
  }

  String? _validateAddress(address) {
    if (address == null || address.isEmpty) {
      return 'Enter your address';
    }

    if (address.length < 5) {
      return 'Address must be at least 5 characters';
    }
    return null;
  }

  String? _validatePhone(phone) {
    if (phone == null || phone.isEmpty) {
      return 'Enter your phone number';
    }
    if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(phone)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validateName(name) {
    if (name == null || name.isEmpty) return 'Name is required';
    if (name.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateConfirm(password) {
    if (password == null || password.isEmpty) {
      return 'Confirm your password';
    }
    if (password != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validatePassword(password) {
    if (password == null || password.isEmpty) {
      return 'Enter password';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? _validateEmail(email) {
    if (email == null || email.isEmpty) {
      return 'Enter your email';
    }
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(email)) {
      return 'Enter a valid email';
    }
    return null;
  }

  void _register(BuildContext context) {
    if (!formKey.currentState!.validate()) return;
    final String fullName =
        '${fNameController.text.trim()} ${lNameController.text.trim()}';
    final RegisterOptions options = RegisterOptions(
      name: fullName,
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    context.read<RegisterBloc>().add(
          RegisterSubmitEvent(
            options,
          ),
        );
  }

  void _toggleVisibility() {
    passwordVisibility.value = !passwordVisibility.value;
  }

  void _toggleConfirmVisibility() {
    confirmVisibility.value = !confirmVisibility.value;
  }
}

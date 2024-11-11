import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/widgets/buttons/primary_button.dart';
import 'package:your_chef/features/auth/presentation/bloc/register/register_bloc.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/fields/custom_text_field.dart';

class RegisterView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController,
      phoneController,
      addressController,
      emailController,
      passwordController,
      confirmController;
  final ValueNotifier<bool> passwordVisibility, confirmVisibility;
  final TabController tabController;
  const RegisterView({
    super.key,
    required this.nameController,
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
    nameController.text = '';
    nameController.clear();
    phoneController.clear();
    addressController.clear();
    emailController.clear();
    passwordController.clear();
    confirmController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterErrorState) {
          AppMessages.showErrorMessage(context, state.message, state.type);
        }

        if (state is RegisterSuccessState) {
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
              CustomTextField(
                keyboardType: TextInputType.name,
                controller: nameController,
                validator: _validateName,
                enabled: state is! RegisterLoadingState,
                hintText: AppStrings.name,
                prefixIcon: const Icon(Icons.person),
              ),
              10.height,
              CustomTextField(
                keyboardType: TextInputType.phone,
                controller: phoneController,
                validator: _validatePhone,
                enabled: state is! RegisterLoadingState,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                hintText: AppStrings.phone,
                prefixIcon: const Icon(Icons.phone),
              ),
              10.height,
              CustomTextField(
                keyboardType: TextInputType.streetAddress,
                controller: addressController,
                validator: _validateAddress,
                enabled: state is! RegisterLoadingState,
                hintText: AppStrings.address,
                prefixIcon: const Icon(Icons.location_pin),
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
                prefixIcon: const Icon(Icons.email),
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
                      prefixIcon: const Icon(Icons.password),
                      suffixIcon: IconButton(
                        onPressed: _toggleVisibility,
                        icon: visible
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
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
                      prefixIcon: const Icon(Icons.password),
                      suffixIcon: IconButton(
                        onPressed: _toggleConfirmVisibility,
                        icon: visible
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
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
    final RegisterOptions options = RegisterOptions(
      name: nameController.text.trim(),
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

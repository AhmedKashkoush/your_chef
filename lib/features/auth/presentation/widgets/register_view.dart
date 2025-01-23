part of '../screens/auth_screen.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({
    super.key,
  });

  void _clearControllers(BuildContext context) {
    final RegisterConfig register =
        AuthInheritedWidget.of(context).registerConfig;
    register.fNameController.clear();
    register.lNameController.clear();
    register.phoneController.clear();
    register.addressController.clear();
    register.emailController.clear();
    register.passwordController.clear();
    register.confirmController.clear();
    register.countryNotifier.value = Country.parse('EG');
    register.genderNotifier.value = Gender.male;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) async {
        final TabController tabController =
            AuthInheritedWidget.of(context).tabController;
        if (state is RegisterErrorState) {
          AppMessages.showErrorMessage(context, state.message, state.type);
        }

        if (state is RegisterSuccessState) {
          await _showProfileUploadScreen(context, state.uid);
          if (!context.mounted) return;
          tabController.animateTo(0);
          _clearControllers(context);
          AppMessages.showSuccessMessage(context, 'Account Created');
        }
      },
      builder: (context, state) {
        final RegisterConfig register =
            AuthInheritedWidget.of(context).registerConfig;
        return Form(
          key: register.formKey,
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40).r,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      keyboardType: TextInputType.name,
                      controller: register.fNameController,
                      validator: _validateName,
                      enabled: state is! RegisterLoadingState,
                      hintText: AppStrings.fName.tr(),
                      prefixIcon: const Icon(HugeIcons.strokeRoundedUser),
                    ),
                  ),
                  10.width,
                  Expanded(
                    child: CustomTextField(
                      keyboardType: TextInputType.name,
                      controller: register.lNameController,
                      validator: _validateName,
                      enabled: state is! RegisterLoadingState,
                      hintText: AppStrings.lName.tr(),
                      prefixIcon: const Icon(HugeIcons.strokeRoundedUser),
                    ),
                  ),
                ],
              ),
              10.height,
              ValueListenableBuilder(
                  valueListenable: register.genderNotifier,
                  builder: (context, gender, _) {
                    return Row(
                      children: [
                        Expanded(
                          child: GenderTile(
                            enabled: state is! RegisterLoadingState,
                            value: Gender.male,
                            selected: gender,
                            onSelect: (gender) =>
                                register.genderNotifier.value = gender,
                          ),
                        ),
                        10.width,
                        Expanded(
                          child: GenderTile(
                            enabled: state is! RegisterLoadingState,
                            value: Gender.female,
                            selected: gender,
                            onSelect: (gender) =>
                                register.genderNotifier.value = gender,
                          ),
                        ),
                      ],
                    );
                  }),
              10.height,
              Row(
                children: [
                  ValueListenableBuilder(
                      valueListenable: register.countryNotifier,
                      builder: (context, country, _) {
                        return CountryPhonePickerWidget(
                          country: country,
                          onSelect: (country) =>
                              register.countryNotifier.value = country,
                        );
                      }),
                  10.width,
                  Expanded(
                    child: CustomTextField(
                      keyboardType: TextInputType.phone,
                      controller: register.phoneController,
                      validator: _validatePhone,
                      enabled: state is! RegisterLoadingState,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(11),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      hintText: AppStrings.phone.tr(),
                    ),
                  ),
                ],
              ),
              10.height,
              CustomTextField(
                keyboardType: TextInputType.streetAddress,
                controller: register.addressController,
                validator: _validateAddress,
                enabled: state is! RegisterLoadingState,
                hintText: AppStrings.address.tr(),
                prefixIcon: const Icon(HugeIcons.strokeRoundedLocation01),
              ),
              10.height,
              CustomTextField(
                keyboardType: TextInputType.emailAddress,
                controller: register.emailController,
                validator: _validateEmail,
                enabled: state is! RegisterLoadingState,
                hintText: AppStrings.email.tr(),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                prefixIcon: const Icon(HugeIcons.strokeRoundedMail01),
              ),
              10.height,
              ValueListenableBuilder(
                  valueListenable: register.passwordVisibility,
                  builder: (_, visible, __) {
                    return CustomTextField(
                      hintText: AppStrings.password.tr(),
                      enabled: state is! RegisterLoadingState,
                      controller: register.passwordController,
                      validator: _validatePassword,
                      obscureText: !visible,
                      obscuringCharacter: '*',
                      prefixIcon:
                          const Icon(HugeIcons.strokeRoundedLockPassword),
                      suffixIcon: IconButton(
                        onPressed: () => _toggleVisibility(context),
                        icon: visible
                            ? const Icon(HugeIcons.strokeRoundedViewOff)
                            : const Icon(HugeIcons.strokeRoundedEye),
                      ),
                    );
                  }),
              10.height,
              ValueListenableBuilder(
                  valueListenable: register.confirmVisibility,
                  builder: (_, visible, __) {
                    return CustomTextField(
                      hintText: AppStrings.confirmPassword.tr(),
                      enabled: state is! RegisterLoadingState,
                      controller: register.confirmController,
                      validator: (value) => _validateConfirm(context, value),
                      obscureText: !visible,
                      obscuringCharacter: '*',
                      prefixIcon:
                          const Icon(HugeIcons.strokeRoundedLockPassword),
                      suffixIcon: IconButton(
                        onPressed: () => _toggleConfirmVisibility(context),
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
                text: AppStrings.register.tr(),
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

  String? _validateName(String? name) {
    if (name == null || name.isEmpty) return 'Name is required';
    if (name.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateConfirm(BuildContext context, String? password) {
    final RegisterConfig register =
        AuthInheritedWidget.of(context).registerConfig;
    if (password == null || password.isEmpty) {
      return 'Confirm your password';
    }
    if (password != register.passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validatePassword(String? password) {
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

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Enter your email';
    }
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(email)) {
      return 'Enter a valid email';
    }
    return null;
  }

  void _register(BuildContext context) {
    final RegisterConfig register =
        AuthInheritedWidget.of(context).registerConfig;
    if (!register.formKey.currentState!.validate()) return;
    final String fullName =
        '${register.fNameController.text.trim()} ${register.lNameController.text.trim()}';
    final RegisterOptions options = RegisterOptions(
      name: fullName,
      gender: register.genderNotifier.value,
      phone:
          "+${register.countryNotifier.value.phoneCode}${register.phoneController.text.trim()}",
      address: register.addressController.text.trim(),
      email: register.emailController.text.trim(),
      password: register.passwordController.text.trim(),
    );

    context.read<RegisterBloc>().add(
          RegisterSubmitEvent(
            options,
          ),
        );
  }

  void _toggleVisibility(BuildContext context) {
    final RegisterConfig register =
        AuthInheritedWidget.of(context).registerConfig;
    register.passwordVisibility.value = !register.passwordVisibility.value;
  }

  void _toggleConfirmVisibility(BuildContext context) {
    final RegisterConfig register =
        AuthInheritedWidget.of(context).registerConfig;
    register.confirmVisibility.value = !register.confirmVisibility.value;
  }
}

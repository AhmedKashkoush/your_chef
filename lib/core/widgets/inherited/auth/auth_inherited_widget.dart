import 'package:flutter/material.dart';

class AuthInheritedWidget extends InheritedWidget {
  final TabController tabController;
  final LoginConfig loginConfig;
  final RegisterConfig registerConfig;

  const AuthInheritedWidget({
    super.key,
    required super.child,
    required this.loginConfig,
    required this.registerConfig,
    required this.tabController,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static AuthInheritedWidget of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AuthInheritedWidget>()!;
}

class LoginConfig {
  final TextEditingController emailController, passwordController;
  final ValueNotifier<bool> passwordVisibility;

  LoginConfig({
    required this.emailController,
    required this.passwordController,
    required this.passwordVisibility,
  });
}

class RegisterConfig {
  final TextEditingController fNameController,
      lNameController,
      emailController,
      passwordController,
      phoneController,
      addressController,
      confirmController;
  final ValueNotifier<bool> passwordVisibility, confirmVisibility;
  final GlobalKey<FormState> formKey;

  RegisterConfig({
    required this.fNameController,
    required this.lNameController,
    required this.emailController,
    required this.passwordController,
    required this.phoneController,
    required this.addressController,
    required this.confirmController,
    required this.passwordVisibility,
    required this.confirmVisibility,
    required this.formKey,
  });
}
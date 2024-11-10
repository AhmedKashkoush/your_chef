import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/widgets/buttons/primary_button.dart';
import 'package:your_chef/features/auth/presentation/bloc/login/login_bloc.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40).r,
          children: [
            CustomTextField(
              keyboardType: TextInputType.emailAddress,
              hintText: AppStrings.email,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
              prefixIcon: const Icon(Icons.email),
            ),
            10.height,
            const CustomTextField(
              hintText: AppStrings.password,
              obscureText: true,
              obscuringCharacter: '*',
              prefixIcon: Icon(Icons.password),
              suffixIcon: Icon(Icons.remove_red_eye),
            ),
            20.height,
            PrimaryButton(onPressed: () {}, text: AppStrings.login),
          ],
        );
      },
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextInputType? keyboardType;
  final Widget? prefixIcon, suffixIcon;
  final bool obscureText;
  final String? hintText, labelText;
  final String obscuringCharacter;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.hintText,
    this.labelText,
    this.obscuringCharacter = '•',
    this.controller,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        isDense: true,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.r),
        ),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.3),
      ),
    );
  }
}

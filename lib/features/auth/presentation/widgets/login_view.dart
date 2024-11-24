import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/widgets/buttons/auth_button.dart';
import 'package:your_chef/core/widgets/buttons/primary_button.dart';
import 'package:your_chef/core/widgets/fields/custom_text_field.dart';
import 'package:your_chef/features/auth/presentation/bloc/login/login_bloc.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController, passwordController;
  final ValueNotifier<bool> passwordVisibility;
  const LoginView({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.passwordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is GoogleLoginLoadingState) {
          AppMessages.showLoadingDialog(
            context,
            message: 'Just a moment...',
          );
        } else {
          if (context.canPop()) {
            context.pop();
          }
          if (state is LoginErrorState) {
            AppMessages.showErrorMessage(context, state.message, state.type);
          }

          if (state is LoginSuccessState) {
            AppMessages.showSuccessMessage(context, 'Login successful');
            context.pushReplacementNamed(AppRoutes.home);
          }
        }
      },
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40).r,
          children: [
            CustomTextField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              enabled: state is! LoginLoadingState,
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
                    enabled: state is! LoginLoadingState,
                    controller: passwordController,
                    obscureText: !visible,
                    obscuringCharacter: '*',
                    prefixIcon: const Icon(HugeIcons.strokeRoundedLockPassword),
                    suffixIcon: IconButton(
                      onPressed: _toggleVisibility,
                      icon: visible
                          ? const Icon(HugeIcons.strokeRoundedViewOff)
                          : const Icon(HugeIcons.strokeRoundedEye),
                    ),
                  );
                }),
            14.height,
            GestureDetector(
              onTap: () => _goToResetEmail(context),
              child: const Text(
                AppStrings.forgotPassword,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: AppColors.primary,
                ),
              ),
            ),
            20.height,
            PrimaryButton(
              onPressed:
                  state is GoogleLoginLoadingState || state is LoginLoadingState
                      ? () {}
                      : () => _login(context),
              loading: state is LoginLoadingState,
              text: AppStrings.login,
            ),
            20.height,
            Row(
              children: [
                Expanded(
                  child: Divider(
                    endIndent: 10.w,
                    color: Colors.grey.withOpacity(0.5),
                    thickness: 1,
                  ),
                ),
                const Text(
                  AppStrings.or,
                  style: TextStyle(color: Colors.grey),
                ),
                Expanded(
                  child: Divider(
                    indent: 10.w,
                    color: Colors.grey.withOpacity(0.5),
                    thickness: 1,
                  ),
                ),
              ],
            ),
            20.height,
            AuthButton(
              onPressed:
                  state is GoogleLoginLoadingState || state is LoginLoadingState
                      ? () {}
                      : () => _googleSignIn(context),
              authType: AuthType.google,
            )
          ],
        );
      },
    );
  }

  void _goToResetEmail(BuildContext context) {
    context.pushNamed(AppRoutes.resetEmail);
  }

  void _googleSignIn(BuildContext context) {
    context.read<LoginBloc>().add(const GoogleSignInEvent());
  }

  void _login(BuildContext context) {
    if (emailController.text.trim().isEmpty &&
        passwordController.text.trim().isEmpty) {
      AppMessages.showErrorMessage(
        context,
        'Enter your credentials',
        ErrorType.auth,
      );
      return;
    }
    if (emailController.text.trim().isEmpty) {
      AppMessages.showErrorMessage(
        context,
        'Enter email',
        ErrorType.auth,
      );
      return;
    }
    if (passwordController.text.trim().isEmpty) {
      AppMessages.showErrorMessage(
        context,
        'Enter password',
        ErrorType.auth,
      );
      return;
    }
    final LoginOptions options = LoginOptions(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    context.read<LoginBloc>().add(LoginSubmitEvent(options));
  }

  void _toggleVisibility() {
    passwordVisibility.value = !passwordVisibility.value;
  }
}

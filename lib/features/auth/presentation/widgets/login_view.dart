part of '../screens/auth_screen.dart';

class LoginView extends StatelessWidget {
  const LoginView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final LoginConfig login = AuthInheritedWidget.of(context).loginConfig;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40).r,
      children: [
        BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return CustomTextField(
              keyboardType: TextInputType.emailAddress,
              controller: login.emailController,
              enabled: state is! LoginLoadingState,
              hintText: AppStrings.email.tr(),
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
              prefixIcon: const Icon(HugeIcons.strokeRoundedMail01),
            );
          },
        ),
        10.height,
        ValueListenableBuilder(
            valueListenable: login.passwordVisibility,
            builder: (_, visible, __) {
              return BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return CustomTextField(
                    hintText: AppStrings.password.tr(),
                    enabled: state is! LoginLoadingState,
                    controller: login.passwordController,
                    obscureText: !visible,
                    obscuringCharacter: '*',
                    prefixIcon: const Icon(HugeIcons.strokeRoundedLockPassword),
                    suffixIcon: IconButton(
                      onPressed: () => _toggleVisibility(context),
                      icon: visible
                          ? const Icon(HugeIcons.strokeRoundedViewOff)
                          : const Icon(HugeIcons.strokeRoundedEye),
                    ),
                  );
                },
              );
            }),
        14.height,
        GestureDetector(
          onTap: () => _goToResetEmail(context),
          child: Text(
            AppStrings.forgotPassword.tr(),
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: AppColors.primary,
            ),
          ),
        ),
        20.height,
        BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginErrorState) {
              AppMessages.showErrorMessage(context, state.message, state.type);
            }

            if (state is LoginSuccessState) {
              AppMessages.showSuccessMessage(
                context,
                AppStrings.loggedInSuccessfully.tr(),
              );
              context.read<UserBloc>().add(SetUserEvent(state.user.user));
              context.pushNamedAndRemoveUntil(
                AppRoutes.home,
                arguments: state.user,
              );
            }
          },
          builder: (context, state) {
            return PrimaryButton(
              onPressed:
                  state is LoginLoadingState ? () {} : () => _login(context),
              loading: state is LoginLoadingState,
              text: AppStrings.login.tr(),
            );
          },
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
            Text(
              AppStrings.or.tr(),
              style: const TextStyle(color: Colors.grey),
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
        BlocConsumer<GoogleSignInBloc, GoogleSignInState>(
          listener: (context, state) {
            if (state is GoogleSignInLoadingState) {
              AppMessages.showLoadingDialog(
                context,
                message: AppStrings.justAMoment.tr(),
              );
            } else {
              if (context.canPop()) context.pop();
              if (state is GoogleSignInErrorState) {
                AppMessages.showErrorMessage(
                    context, state.message, state.type);
              }

              if (state is GoogleSignInSuccessState) {
                AppMessages.showSuccessMessage(
                  context,
                  AppStrings.loggedInSuccessfully.tr(),
                );
                context.read<UserBloc>().add(SetUserEvent(state.user.user));
                context.pushNamedAndRemoveUntil(
                  AppRoutes.home,
                  arguments: state.user,
                );
              }
            }
          },
          builder: (context, state) => AuthButton(
            onPressed: state is GoogleSignInLoadingState
                ? () {}
                : () => _googleSignIn(context),
            authType: AuthType.google,
          ),
        )
      ],
    );
  }

  void _goToResetEmail(BuildContext context) {
    context.pushNamed(AppRoutes.resetEmail);
  }

  void _googleSignIn(BuildContext context) {
    context.read<GoogleSignInBloc>().add(const GoogleSignInEventStarted());
  }

  void _login(BuildContext context) {
    final LoginConfig login = AuthInheritedWidget.of(context).loginConfig;
    if (login.emailController.text.trim().isEmpty &&
        login.passwordController.text.trim().isEmpty) {
      AppMessages.showErrorMessage(
        context,
        'Enter your credentials',
        ErrorType.auth,
      );
      return;
    }
    if (login.emailController.text.trim().isEmpty) {
      AppMessages.showErrorMessage(
        context,
        'Enter email',
        ErrorType.auth,
      );
      return;
    }
    if (login.passwordController.text.trim().isEmpty) {
      AppMessages.showErrorMessage(
        context,
        'Enter password',
        ErrorType.auth,
      );
      return;
    }
    final LoginOptions options = LoginOptions(
      email: login.emailController.text.trim(),
      password: login.passwordController.text.trim(),
    );
    context.read<LoginBloc>().add(LoginSubmitEvent(options));
  }

  void _toggleVisibility(BuildContext context) {
    final LoginConfig login = AuthInheritedWidget.of(context).loginConfig;
    login.passwordVisibility.value = !login.passwordVisibility.value;
  }
}

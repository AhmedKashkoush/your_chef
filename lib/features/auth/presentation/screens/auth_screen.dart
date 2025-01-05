import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/common/blocs/user/user_bloc.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/extensions/media_query_extension.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/widgets/buttons/auth_button.dart';
import 'package:your_chef/core/widgets/buttons/primary_button.dart';
import 'package:your_chef/core/widgets/fields/custom_text_field.dart';
import 'package:your_chef/core/widgets/icons/app_logo.dart';
import 'package:your_chef/core/widgets/inherited/auth/auth_inherited_widget.dart';
import 'package:your_chef/core/widgets/layout/orientation_widget.dart';
import 'package:your_chef/core/widgets/texts/logo_text.dart';
import 'package:your_chef/features/auth/presentation/bloc/google_sign_in/google_sign_in_bloc.dart';
import 'package:your_chef/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:your_chef/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:your_chef/features/auth/presentation/screens/upload_profile_photo_screen.dart';

part '../widgets/auth_tab_bar_view_widget.dart';
part '../widgets/auth_tab_bar_widget.dart';
part '../widgets/login_view.dart';
part '../widgets/register_view.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 2, vsync: this);

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  final TextEditingController _loginEmailController = TextEditingController(),
      _loginPasswordController = TextEditingController(),
      _registerFNameController = TextEditingController(),
      _registerLNameController = TextEditingController(),
      _registerEmailController = TextEditingController(),
      _registerPasswordController = TextEditingController(),
      _registerPhoneController = TextEditingController(),
      _registerAddressController = TextEditingController(),
      _registerConfirmController = TextEditingController();
  final ValueNotifier<bool> _loginPasswordVisibility =
          ValueNotifier<bool>(false),
      _registerPasswordVisibility = ValueNotifier<bool>(false),
      _registerConfirmVisibility = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _loginPasswordVisibility.dispose();
    _registerFNameController.dispose();
    _registerLNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerPhoneController.dispose();
    _registerAddressController.dispose();
    _registerConfirmController.dispose();
    _registerPasswordVisibility.dispose();
    _registerConfirmVisibility.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text.rich(
          TextSpan(
              text: '${AppStrings.freePalestine.split(' ').first} ',
              children: [
                TextSpan(
                  text: AppStrings.freePalestine.split(' ')[1],
                  style: const TextStyle(
                    color: Colors.green,
                  ),
                ),
              ]),
          style: const TextStyle(
            color: Colors.red,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: AuthInheritedWidget(
        tabController: _tabController,
        loginConfig: LoginConfig(
          emailController: _loginEmailController,
          passwordController: _loginPasswordController,
          passwordVisibility: _loginPasswordVisibility,
        ),
        registerConfig: RegisterConfig(
          formKey: _registerFormKey,
          fNameController: _registerFNameController,
          lNameController: _registerLNameController,
          emailController: _registerEmailController,
          passwordController: _registerPasswordController,
          phoneController: _registerPhoneController,
          addressController: _registerAddressController,
          passwordVisibility: _registerPasswordVisibility,
          confirmController: _registerConfirmController,
          confirmVisibility: _registerConfirmVisibility,
        ),
        child: OrientationWidget(
          portrait: _AuthScreenPortrait(),
          landscape: _AuthScreenLandscape(
            keyboardShown: context.keyboardShown,
          ),
        ),
      ),
    );
  }
}

class _AuthScreenPortrait extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const AppLogo(),
          10.height,
          const Text(
            AppStrings.welcome,
            style: TextStyle(fontSize: 18),
          ),
          const LogoText(),
          10.height,
          const AuthTabBarWidget(),
          const Expanded(
            child: AuthTabBarViewWidget(),
          ),
        ],
      ),
    );
  }
}

class _AuthScreenLandscape extends StatelessWidget {
  final bool keyboardShown;

  const _AuthScreenLandscape({
    required this.keyboardShown,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: keyboardShown
                ? Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const FittedBox(child: AppLogo()),
                      4.width,
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.welcome,
                            style: TextStyle(fontSize: 18),
                          ),
                          LogoText(),
                        ],
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FittedBox(child: AppLogo()),
                      10.height,
                      const Text(
                        AppStrings.welcome,
                        style: TextStyle(fontSize: 18),
                      ),
                      const LogoText(),
                    ],
                  ),
          ),
          const Expanded(
            flex: 2,
            child: Column(
              children: [
                AuthTabBarWidget(),
                Expanded(
                  child: AuthTabBarViewWidget(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

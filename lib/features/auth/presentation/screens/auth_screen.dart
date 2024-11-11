import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/widgets/icons/app_logo.dart';
import 'package:your_chef/core/widgets/layout/orientation_widget.dart';
import 'package:your_chef/core/widgets/texts/logo_text.dart';
import 'package:your_chef/features/auth/presentation/widgets/login_view.dart';
import 'package:your_chef/features/auth/presentation/widgets/register_view.dart';

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
      _registerNameController = TextEditingController(),
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
    _registerNameController.dispose();
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
        title: const Text.rich(
          TextSpan(text: 'Free ', children: [
            TextSpan(
              text: 'Palestine',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
          ]),
          style: TextStyle(
            color: Colors.red,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: OrientationWidget(
        portrait: _AuthScreenPortrait(
          tabController: _tabController,
          loginEmailController: _loginEmailController,
          loginPasswordController: _loginPasswordController,
          loginPasswordVisibility: _loginPasswordVisibility,
          registerFormKey: _registerFormKey,
          registerNameController: _registerNameController,
          registerEmailController: _registerEmailController,
          registerPasswordController: _registerPasswordController,
          registerPhoneController: _registerPhoneController,
          registerAddressController: _registerAddressController,
          registerConfirmController: _registerConfirmController,
          registerPasswordVisibility: _registerPasswordVisibility,
          registerConfirmVisibility: _registerConfirmVisibility,
        ),
        landscape: _AuthScreenLandscape(
          tabController: _tabController,
          loginEmailController: _loginEmailController,
          loginPasswordController: _loginPasswordController,
          loginPasswordVisibility: _loginPasswordVisibility,
          registerFormKey: _registerFormKey,
          registerNameController: _registerNameController,
          registerEmailController: _registerEmailController,
          registerPasswordController: _registerPasswordController,
          registerPhoneController: _registerPhoneController,
          registerAddressController: _registerAddressController,
          registerConfirmController: _registerConfirmController,
          registerPasswordVisibility: _registerPasswordVisibility,
          registerConfirmVisibility: _registerConfirmVisibility,
        ),
      ),
    );
  }
}

class _AuthScreenPortrait extends StatelessWidget {
  final TabController tabController;
  final GlobalKey<FormState> registerFormKey;
  final TextEditingController loginEmailController,
      loginPasswordController,
      registerNameController,
      registerEmailController,
      registerPasswordController,
      registerPhoneController,
      registerAddressController,
      registerConfirmController;
  final ValueNotifier<bool> loginPasswordVisibility,
      registerPasswordVisibility,
      registerConfirmVisibility;
  const _AuthScreenPortrait({
    required this.tabController,
    required this.loginEmailController,
    required this.loginPasswordController,
    required this.loginPasswordVisibility,
    required this.registerFormKey,
    required this.registerNameController,
    required this.registerEmailController,
    required this.registerPasswordController,
    required this.registerPhoneController,
    required this.registerAddressController,
    required this.registerConfirmController,
    required this.registerPasswordVisibility,
    required this.registerConfirmVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const AppLogo(),
          10.height,
          Text(
            AppStrings.welcome,
            style: TextStyle(fontSize: 18.sp),
          ),
          const LogoText(),
          10.height,
          _TabBarWidget(tabController: tabController),
          Expanded(
            child: _TabBarViewWidget(
              tabController: tabController,
              loginEmailController: loginEmailController,
              loginPasswordController: loginPasswordController,
              loginPasswordVisibility: loginPasswordVisibility,
              registerFormKey: registerFormKey,
              registerNameController: registerNameController,
              registerEmailController: registerEmailController,
              registerPasswordController: registerPasswordController,
              registerPhoneController: registerPhoneController,
              registerAddressController: registerAddressController,
              registerConfirmController: registerConfirmController,
              registerPasswordVisibility: registerPasswordVisibility,
              registerConfirmVisibility: registerConfirmVisibility,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthScreenLandscape extends StatelessWidget {
  final TabController tabController;
  final GlobalKey<FormState> registerFormKey;
  final TextEditingController loginEmailController,
      loginPasswordController,
      registerNameController,
      registerEmailController,
      registerPasswordController,
      registerPhoneController,
      registerAddressController,
      registerConfirmController;
  final ValueNotifier<bool> loginPasswordVisibility,
      registerPasswordVisibility,
      registerConfirmVisibility;
  const _AuthScreenLandscape({
    required this.tabController,
    required this.loginEmailController,
    required this.loginPasswordController,
    required this.loginPasswordVisibility,
    required this.registerFormKey,
    required this.registerNameController,
    required this.registerEmailController,
    required this.registerPasswordController,
    required this.registerPhoneController,
    required this.registerAddressController,
    required this.registerConfirmController,
    required this.registerPasswordVisibility,
    required this.registerConfirmVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FittedBox(child: AppLogo()),
                10.height,
                Text(
                  AppStrings.welcome,
                  style: TextStyle(fontSize: 10.sp),
                ),
                const LogoText(),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _TabBarWidget(tabController: tabController),
                Expanded(
                  child: _TabBarViewWidget(
                    tabController: tabController,
                    registerFormKey: registerFormKey,
                    loginEmailController: loginEmailController,
                    loginPasswordController: loginPasswordController,
                    loginPasswordVisibility: loginPasswordVisibility,
                    registerNameController: registerNameController,
                    registerEmailController: registerEmailController,
                    registerPasswordController: registerPasswordController,
                    registerPhoneController: registerPhoneController,
                    registerAddressController: registerAddressController,
                    registerConfirmController: registerConfirmController,
                    registerPasswordVisibility: registerPasswordVisibility,
                    registerConfirmVisibility: registerConfirmVisibility,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBarViewWidget extends StatelessWidget {
  final TabController tabController;
  final GlobalKey<FormState> registerFormKey;
  final TextEditingController loginEmailController,
      loginPasswordController,
      registerNameController,
      registerEmailController,
      registerPasswordController,
      registerPhoneController,
      registerAddressController,
      registerConfirmController;
  final ValueNotifier<bool> loginPasswordVisibility,
      registerPasswordVisibility,
      registerConfirmVisibility;
  const _TabBarViewWidget({
    required this.tabController,
    required this.loginEmailController,
    required this.loginPasswordController,
    required this.loginPasswordVisibility,
    required this.registerNameController,
    required this.registerEmailController,
    required this.registerPasswordController,
    required this.registerPhoneController,
    required this.registerAddressController,
    required this.registerConfirmController,
    required this.registerPasswordVisibility,
    required this.registerConfirmVisibility,
    required this.registerFormKey,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        LoginView(
          emailController: loginEmailController,
          passwordController: loginPasswordController,
          passwordVisibility: loginPasswordVisibility,
        ),
        RegisterView(
          tabController: tabController,
          formKey: registerFormKey,
          nameController: registerNameController,
          emailController: registerEmailController,
          passwordController: registerPasswordController,
          phoneController: registerPhoneController,
          addressController: registerAddressController,
          confirmController: registerConfirmController,
          passwordVisibility: registerPasswordVisibility,
          confirmVisibility: registerConfirmVisibility,
        ),
      ],
    );
  }
}

class _TabBarWidget extends StatelessWidget {
  const _TabBarWidget({
    required this.tabController,
  });

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.label,
      controller: tabController,
      indicatorColor: AppColors.primary,
      labelColor: AppColors.primary,
      tabs: const [
        Tab(
          text: AppStrings.login,
        ),
        Tab(
          text: AppStrings.register,
        ),
      ],
    );
  }
}

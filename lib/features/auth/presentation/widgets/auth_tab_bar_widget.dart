part of '../screens/auth_screen.dart';

class AuthTabBarWidget extends StatelessWidget {
  const AuthTabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthInheritedWidget auth = AuthInheritedWidget.of(context);
    return TabBar(
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.label,
      controller: auth.tabController,
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
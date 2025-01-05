part of '../screens/auth_screen.dart';

class AuthTabBarViewWidget extends StatelessWidget {
  const AuthTabBarViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TabController tabController =
        AuthInheritedWidget.of(context).tabController;
    return TabBarView(
      controller: tabController,
      children: const [
        LoginView(),
        RegisterView(),
      ],
    );
  }
}

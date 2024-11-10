import 'package:flutter/material.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/widgets/icons/app_logo.dart';
import 'package:your_chef/core/widgets/layout/orientation_widget.dart';
import 'package:your_chef/core/widgets/texts/logo_text.dart';
import 'package:your_chef/features/auth/presentation/widgets/login_view.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 2, vsync: this);
  @override
  Widget build(BuildContext context) {
    return OrientationWidget(
      portrait: _AuthScreenPortrait(
        tabController: _tabController,
      ),
      landscape: const SizedBox.shrink(),
    );
  }
}

class _AuthScreenPortrait extends StatelessWidget {
  final TabController tabController;
  const _AuthScreenPortrait({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          children: [
            const AppLogo(),
            10.height,
            const Text(
              AppStrings.welcome,
              style: TextStyle(fontSize: 22),
            ),
            const LogoText(),
            10.height,
            _TabBarWidget(tabController: tabController),
            Expanded(
              child: _TabBarViewWidget(tabController: tabController),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabBarViewWidget extends StatelessWidget {
  const _TabBarViewWidget({
    required this.tabController,
  });

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: const [
        LoginView(),
        SizedBox.shrink(),
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

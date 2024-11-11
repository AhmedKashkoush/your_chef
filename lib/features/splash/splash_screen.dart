import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/keys.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/utils/shared_preferences_helper.dart';
import 'package:your_chef/core/widgets/icons/app_logo.dart';
import 'package:your_chef/core/widgets/texts/logo_text.dart';
import 'package:your_chef/locator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      final bool onboarding =
          SharedPreferencesHelper.get<bool>(SharedPrefsKeys.onboarding) ??
              false;
      if (!onboarding) {
        context.pushReplacementNamed(AppRoutes.onboarding);
      } else {
        if (locator<SupabaseClient>().auth.currentUser == null) {
          context.pushReplacementNamed(AppRoutes.auth);
        } else {
          context.pushReplacementNamed(AppRoutes.home);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(
              flex: 2,
            ),
            const AppLogo(),
            10.height,
            const LogoText(),
            const Spacer(),
            const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

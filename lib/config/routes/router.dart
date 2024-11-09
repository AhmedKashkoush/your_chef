import 'package:flutter/material.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/features/splash/splash_screen.dart';

class AppRouter {
  static String initialRoute = AppRoutes.splash;
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      default:
        return null;
    }
  }
}

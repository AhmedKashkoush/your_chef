import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/widgets/home_wrapper/home_wrapper.dart';
import 'package:your_chef/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:your_chef/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:your_chef/features/auth/presentation/screens/auth_screen.dart';
import 'package:your_chef/features/onboarding/screens/onboarding_screen.dart';
import 'package:your_chef/features/splash/splash_screen.dart';
import 'package:your_chef/locator.dart';

class AppRouter {
  static String initialRoute = AppRoutes.splash;
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );
      case AppRoutes.auth:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => locator<LoginBloc>(),
              ),
              BlocProvider(
                create: (_) => locator<RegisterBloc>(),
              ),
            ],
            child: const AuthScreen(),
          ),
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomeWrapper(),
        );
      default:
        return null;
    }
  }
}

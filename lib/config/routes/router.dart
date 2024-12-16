import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/widgets/home_wrapper/home_wrapper.dart';
import 'package:your_chef/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:your_chef/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:your_chef/features/auth/presentation/screens/auth_screen.dart';
import 'package:your_chef/features/auth/presentation/screens/email_reset_screen.dart';
import 'package:your_chef/features/auth/presentation/screens/otp_screen.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';
import 'package:your_chef/features/onboarding/screens/onboarding_screen.dart';
import 'package:your_chef/features/foods/presentation/screens/food_details_screen.dart';
import 'package:your_chef/features/profile/presentation/screens/profile_screen.dart';
import 'package:your_chef/features/restaurants/presentation/screens/restaurant_details_screen.dart';
import 'package:your_chef/features/settings/presentation/screens/themes_screen.dart';
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
      case AppRoutes.resetEmail:
        return _slideTransition(
          const EmailResetScreen(),
        );
      case AppRoutes.otp:
        return MaterialPageRoute(
          builder: (_) => OtpScreen(
            options: ResetPasswordOptions(
              email: (settings.arguments as Map<String, dynamic>)['email'],
              phone: (settings.arguments as Map<String, dynamic>)['phone'],
            ),
          ),
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (context) => const HomeWrapper(),
        );
      case AppRoutes.food:
        return MaterialPageRoute(
          builder: (_) {
            final Map<String, dynamic> args =
                settings.arguments as Map<String, dynamic>;
            return FoodDetailsScreen(
              food: args['food'] as Food,
              tag: args['tag'] as String,
            );
          },
        );
      case AppRoutes.restaurant:
        return MaterialPageRoute(
          builder: (_) {
            final Map<String, dynamic> args =
                settings.arguments as Map<String, dynamic>;
            return RestaurantDetailsScreen(
              restaurant: args['restaurant'] as Restaurant,
              tag: args['tag'] as String,
            );
          },
        );
      case AppRoutes.themes:
        return _slideTransition(
          const ThemesScreen(),
        );
      case AppRoutes.profile:
        return _slideTransition(
          ProfileScreen(
            profileTag: settings.arguments as String,
          ),
        );
      default:
        return null;
    }
  }

  static PageRouteBuilder _slideTransition(Widget page) {
    return PageRouteBuilder(
      transitionsBuilder: (_, animation, __, child) => SlideTransition(
        position:
            Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
        ),
        child: child,
      ),
      pageBuilder: (_, __, ___) => page,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/common/blocs/cart/cart_bloc.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/widgets/home_wrapper/home_wrapper.dart';
import 'package:your_chef/features/auth/presentation/bloc/google_sign_in/google_sign_in_bloc.dart';
import 'package:your_chef/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:your_chef/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:your_chef/features/auth/presentation/screens/accounts_screen.dart';
import 'package:your_chef/features/auth/presentation/screens/auth_screen.dart';
import 'package:your_chef/features/auth/presentation/screens/email_reset_screen.dart';
import 'package:your_chef/features/auth/presentation/screens/otp_screen.dart';
import 'package:your_chef/features/categories/presentation/screens/categories_screen.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/foods/presentation/screens/cart_screen.dart';
import 'package:your_chef/features/foods/presentation/screens/explore_foods_screen.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';
import 'package:your_chef/features/onboarding/screens/onboarding_screen.dart';
import 'package:your_chef/features/foods/presentation/screens/food_details_screen.dart';
import 'package:your_chef/features/settings/presentation/screens/languages_screen.dart';
import 'package:your_chef/features/settings/presentation/screens/profile_screen.dart';
import 'package:your_chef/features/restaurants/presentation/screens/restaurant_details_screen.dart';
import 'package:your_chef/features/settings/presentation/screens/themes_screen.dart';
import 'package:your_chef/features/splash/splash_screen.dart';
import 'package:your_chef/features/auth/domain/entities/saved_user.dart';
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
                create: (_) => locator<GoogleSignInBloc>(),
              ),
              BlocProvider(
                create: (_) => locator<RegisterBloc>(),
              ),
            ],
            child: const AuthScreen(),
          ),
        );
      case AppRoutes.accounts:
        return MaterialPageRoute(
          builder: (_) => const AccountsScreen(),
        );
      case AppRoutes.resetEmail:
        return _slideTransition(
          builder: (_) => const EmailResetScreen(),
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
        CartBloc? bloc;
        return MaterialPageRoute(
          builder: (context) {
            bloc ??= context.read<CartBloc>()..add(GetCartEvent());
            return BlocProvider.value(
              value: bloc!,
              child: HomeWrapper(
                savedUser: settings.arguments as SavedUser?,
              ),
            );
          },
        );
      case AppRoutes.categories:
        return _slideTransition(builder: (_) => const CategoriesScreen());
      case AppRoutes.foods:
        final String? selected = settings.arguments as String?;
        return _slideTransition(
          builder: (_) => ExploreFoodsScreen(
            selected: selected ?? AppStrings.popularFoods,
          ),
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
      case AppRoutes.cart:
        CartBloc? bloc;
        return _slideTransition(
          builder: (context) {
            bloc ??= context.read<CartBloc>()..add(GetCartEvent());

            return BlocProvider.value(
              value: bloc!,
              child: const CartScreen(),
            );
          },
        );
      case AppRoutes.languages:
        return _slideTransition(
          builder: (_) => const LanguagesScreen(),
        );
      case AppRoutes.themes:
        return _slideTransition(
          builder: (_) => const ThemesScreen(),
        );
      case AppRoutes.profile:
        return _slideTransition(
          builder: (_) => ProfileScreen(
            profileTag: settings.arguments as String,
          ),
        );
      default:
        return null;
    }
  }

  static PageRouteBuilder _slideTransition(
      {required Widget Function(BuildContext) builder}) {
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
      pageBuilder: (context, _, __) => builder.call(context),
    );
  }
}

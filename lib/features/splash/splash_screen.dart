import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/keys.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/core/utils/shared_preferences_helper.dart';
import 'package:your_chef/core/widgets/icons/app_logo.dart';
import 'package:your_chef/core/widgets/texts/logo_text.dart';
import 'package:your_chef/features/user/presentation/bloc/user_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _loading = false;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;
      final bool onboarding =
          SharedPreferencesHelper.get<bool>(SharedPrefsKeys.onboarding) ??
              false;
      if (!onboarding) {
        context.pushReplacementNamed(AppRoutes.onboarding);
      } else {
        setState(() {
          _loading = true;
        });
        // await UserHelper.checkUser();
        if (!mounted) return;
        context.read<UserBloc>()
          ..add(const GetSavedUsersEvent())
          ..add(const GetUserEvent());
        // if (UserHelper.user == null) {
        //   context.pushReplacementNamed(AppRoutes.auth);
        // } else {
        //   context.pushReplacementNamed(AppRoutes.home);
        // }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state.status == RequestStatus.success) {
          if (state.user == null) {
            return;
          }
          context.pushReplacementNamed(AppRoutes.home);
        }

        if (state.status == RequestStatus.failure) {
          if (state.savedUsers.isNotEmpty) {
            context.pushReplacementNamed(AppRoutes.accounts);
            return;
          }
          context.pushReplacementNamed(AppRoutes.auth);
        }
      },
      child: Scaffold(
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
              if (_loading)
                const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

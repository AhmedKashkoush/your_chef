import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/core/widgets/icons/app_logo.dart';
import 'package:your_chef/core/widgets/loading/pizza_loading.dart';
import 'package:your_chef/core/widgets/texts/logo_text.dart';
import 'package:your_chef/common/blocs/user/user_bloc.dart';
import 'package:your_chef/features/splash/cubit/splash_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..init(),
      child: Builder(builder: (context) {
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
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppLogo(),
                      10.height,
                      const LogoText(),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 100.h,
                  child: BlocConsumer<SplashCubit, SplashState>(
                    listener: (context, state) {
                      if (state is SplashUnSkippedOnboardingState) {
                        context.pushReplacementNamed(AppRoutes.onboarding);
                      }

                      if (state is SplashLoadingState) {
                        context.read<UserBloc>()
                          ..add(const GetSavedUsersEvent())
                          ..add(const GetUserEvent());
                      }
                    },
                    builder: (context, state) {
                      return AnimatedOpacity(
                        opacity: state is SplashLoadingState ? 1 : 0,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                        child: AnimatedScale(
                          scale: state is SplashLoadingState ? 1 : 0,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                          child: const Center(
                            child: PizzaLoading(
                              color: AppColors.primary,
                              size: 80,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

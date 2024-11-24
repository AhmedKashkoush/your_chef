import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/urls.dart';
import 'package:your_chef/core/extensions/media_query_extension.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/utils/url_helper.dart';
import 'package:your_chef/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:your_chef/features/settings/presentation/widgets/action_tile.dart';
import 'package:your_chef/features/settings/presentation/widgets/user_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool darkMode = context.theme.brightness == Brightness.dark;
    return Row(
      children: [
        if (context.isLandscape)
          Container(
            width: 36.w,
            color: context.theme.colorScheme.surface,
          ),
        Expanded(
          child: Scaffold(
            backgroundColor: context.theme.colorScheme.surface,
            body: BlocListener<SettingsBloc, SettingsState>(
              listener: (context, state) {
                if (state is SettingsLoadingState) {
                  AppMessages.showLoadingDialog(
                    context,
                    message: 'Signing out...',
                  );
                } else {
                  context.pop();
                  if (state is SettingsErrorState) {
                    AppMessages.showErrorMessage(
                      context,
                      state.message,
                      state.type,
                    );
                  }
                  if (state is SettingsSuccessState) {
                    if (!context.mounted) return;
                    AppMessages.showSuccessMessage(
                      context,
                      'Sign out successful',
                    );
                    context.pushReplacementNamed(AppRoutes.auth);
                  }
                }
              },
              child: SafeArea(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 24,
                  ).r,
                  children: [
                    UserTile(
                      onTap: () => _goToProfile(context),
                      onSignOut: () => _signOut(context),
                    ),
                    16.height,
                    const Divider(),
                    16.height,
                    ActionTile(
                      onTap: () {},
                      title: 'Switch Accounts',
                      icon: HugeIcons.strokeRoundedUserSwitch,
                    ),
                    8.height,
                    ActionTile(
                      onTap: () {},
                      title: 'Privacy & Security',
                      icon: HugeIcons.strokeRoundedLockKey,
                    ),
                    8.height,
                    ActionTile(
                      onTap: _openNotifications,
                      title: 'Notifications',
                      icon: HugeIcons.strokeRoundedNotification03,
                    ),
                    8.height,
                    ActionTile(
                      onTap: () {},
                      title: 'Languages',
                      icon: HugeIcons.strokeRoundedLanguageSquare,
                    ),
                    8.height,
                    ActionTile(
                      onTap: () => _goToThemes(context),
                      title: 'Themes',
                      icon: darkMode
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                    ),
                    8.height,
                    const Divider(),
                    8.height,
                    ActionTile(
                      onTap: () => UrlHelper.openUrl(AppUrls.privacyPolicy),
                      title: 'Terms & Conditions',
                      icon: HugeIcons.strokeRoundedSecurity,
                    ),
                    8.height,
                    ActionTile(
                      onTap: () {},
                      title: 'Report An Issue',
                      icon: HugeIcons.strokeRoundedAlert02,
                    ),
                    8.height,
                    ActionTile(
                      onTap: () {},
                      title: 'About The App',
                      icon: HugeIcons.strokeRoundedInformationCircle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openNotifications() {
    AppSettings.openAppSettings(
      type: AppSettingsType.notification,
    );
  }

  void _goToThemes(BuildContext context) => context.pushNamed(AppRoutes.themes);

  void _signOut(BuildContext context) async {
    final bool? confirm = await AppMessages.showConfirmDialog(
      context,
      message: 'Are you sure you want to sign out?',
      confirmIsDanger: true,
    );

    if (confirm == null || !confirm) return;
    if (!context.mounted) return;

    context.read<SettingsBloc>().add(const SignOutEvent());
  }

  void _goToProfile(BuildContext context) =>
      context.pushNamed(AppRoutes.profile, arguments: 'user-image-settings');
}

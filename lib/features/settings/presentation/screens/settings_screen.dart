import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/constants/urls.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/extensions/media_query_extension.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/utils/url_helper.dart';
import 'package:your_chef/core/utils/user_helper.dart';
import 'package:your_chef/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:your_chef/features/settings/presentation/widgets/accounts_bottom_sheet.dart';
import 'package:your_chef/features/settings/presentation/widgets/action_tile.dart';
import 'package:your_chef/features/settings/presentation/widgets/user_tile.dart';
import 'package:your_chef/locator.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _switchAccount(BuildContext context, SavedUser savedUser) {
    context.read<SettingsBloc>().add(
          SwitchAccountEvent(
            savedUser,
          ),
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

  void _openAccountsSheet(context) async {
    if (!context.mounted) return;
    final SavedUser? savedUser = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => AccountsBottomSheet(
        savedUsers: UserHelper.savedUsers,
      ),
    );

    if (savedUser == null) return;

    if (!context.mounted) return;
    _switchAccount(context, savedUser);
  }

  void _openPrivacyPolicy() => UrlHelper.openUrl(AppUrls.privacyPolicy);

  void _goToLanguages(BuildContext context) {}

  void _reportAnIssue() {}

  void _goToAboutApp(BuildContext context) {}

  void _goToPrivacyAndSecurity(BuildContext context) {}

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
                    message: AppStrings.signingOut,
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
                      AppStrings.signedOutSuccessfully,
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
                    BlocProvider(
                      create: (context) => locator<SettingsBloc>(),
                      child: Builder(builder: (context) {
                        return BlocListener<SettingsBloc, SettingsState>(
                          listener: (context, state) {
                            if (state is SettingsLoadingState) {
                              AppMessages.showLoadingDialog(
                                context,
                                message: AppStrings.switchingAccount,
                              );
                            } else {
                              context.pop();
                              if (state is SettingsErrorState) {
                                AppMessages.showErrorMessage(
                                  context,
                                  state.message,
                                  state.type,
                                );

                                if (state.type == ErrorType.auth) {
                                  context.pushNamedAndRemoveUntil(
                                    AppRoutes.auth,
                                  );
                                }
                              }

                              if (state is SettingsSuccessState) {
                                if (!context.mounted) return;
                                AppMessages.showSuccessMessage(
                                  context,
                                  AppStrings.switchedAccountSuccessfully,
                                );
                                context.pushReplacementNamed(AppRoutes.home);
                              }
                            }
                          },
                          child: ActionTile(
                            onTap: () => _openAccountsSheet(context),
                            title: AppStrings.switchAccounts,
                            icon: HugeIcons.strokeRoundedUserSwitch,
                          ),
                        );
                      }),
                    ),
                    8.height,
                    ActionTile(
                      onTap: () => _goToPrivacyAndSecurity(context),
                      title: AppStrings.privacyAndSecurity,
                      icon: HugeIcons.strokeRoundedLockKey,
                    ),
                    8.height,
                    ActionTile(
                      onTap: _openNotifications,
                      title: AppStrings.notifications,
                      icon: HugeIcons.strokeRoundedNotification03,
                    ),
                    8.height,
                    ActionTile(
                      onTap: () => _goToLanguages(context),
                      title: AppStrings.languages,
                      icon: HugeIcons.strokeRoundedLanguageSquare,
                    ),
                    8.height,
                    ActionTile(
                      onTap: () => _goToThemes(context),
                      title: AppStrings.themes,
                      icon: darkMode
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                    ),
                    8.height,
                    const Divider(),
                    8.height,
                    ActionTile(
                      onTap: _openPrivacyPolicy,
                      title: AppStrings.privacyPolicy,
                      icon: HugeIcons.strokeRoundedSecurity,
                    ),
                    8.height,
                    ActionTile(
                      onTap: _reportAnIssue,
                      title: AppStrings.reportAnIssue,
                      icon: HugeIcons.strokeRoundedAlert02,
                    ),
                    8.height,
                    ActionTile(
                      onTap: () => _goToAboutApp(context),
                      title: AppStrings.aboutTheApp,
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
}

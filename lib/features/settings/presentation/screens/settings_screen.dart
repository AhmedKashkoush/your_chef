import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/constants/urls.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/core/utils/url_helper.dart';
// import 'package:your_chef/core/utils/user_helper.dart';
import 'package:your_chef/features/settings/presentation/bloc/signout/signout_bloc.dart';
import 'package:your_chef/features/settings/presentation/widgets/accounts_bottom_sheet.dart';
import 'package:your_chef/features/settings/presentation/widgets/action_tile.dart';
import 'package:your_chef/features/settings/presentation/widgets/user_tile.dart';
import 'package:your_chef/features/auth/domain/entities/saved_user.dart';
import 'package:your_chef/common/blocs/user/user_bloc.dart';
import 'package:your_chef/locator.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _switchAccount(BuildContext context, SavedUser savedUser) {
    context.read<UserBloc>().add(
          SwitchUserEvent(
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

  void _openAccountsSheet(context) async {
    if (!context.mounted) return;
    final SavedUser? savedUser = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          // final List<SavedUser> sortedList =
          //     List<SavedUser>.from(state.savedUsers)
          //         .where((user) => user.user.id != state.user!.id)
          //         .toList()
          //       ..sort((a, b) => b.lastLogin.compareTo(a.lastLogin));
          return AccountsBottomSheet(
            savedUsers: List<SavedUser>.from(state.savedUsers)
                .where((user) => user.user.id != state.user!.id)
                .toList(),
          );
        },
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
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 24,
          ).r,
          children: [
            BlocProvider(
              create: (context) => locator<SignOutBloc>(),
              child: const UserTile(),
            ),
            16.height,
            const Divider(),
            16.height,
            BlocListener<UserBloc, UserState>(
              listenWhen: (previous, state) =>
                  state.switchUser && previous.status != state.status,
              listener: (context, state) {
                if (state.status == RequestStatus.loading) {
                  AppMessages.showLoadingDialog(
                    context,
                    message: AppStrings.switchingAccount,
                  );
                } else {
                  context.pop();
                  if (state.status == RequestStatus.failure) {
                    AppMessages.showErrorMessage(
                      context,
                      state.error,
                      state.errorType,
                    );

                    if (state.errorType == ErrorType.auth) {
                      context.pushNamedAndRemoveUntil(
                        AppRoutes.auth,
                      );
                    }
                  }

                  if (state.status == RequestStatus.success) {
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
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/widgets/avatars/user_avatar.dart';
import 'package:your_chef/core/widgets/tiles/custom_list_tile.dart';
import 'package:your_chef/common/blocs/user/user_bloc.dart';
import 'package:your_chef/features/settings/presentation/bloc/signout/signout_bloc.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return CustomListTile(
          onTap: () => _goToProfile(context),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8).r,
          horizontalTitleGap: 8,
          leading: Hero(
            tag: 'user-image-settings',
            child: UserAvatar(
              url: state.user?.image ?? '',
              radius: 48,
            ),
          ),
          // minLeadingWidth: 48,
          title: Text(
            state.user?.name ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            state.user?.email ?? '',
            maxLines: 1,
            style: TextStyle(
              color: context.theme.iconTheme.color?.withOpacity(0.3),
            ),
          ),
          trailing: BlocListener<SignOutBloc, SignOutState>(
            listener: (context, state) {
              if (state is SignOutLoadingState) {
                AppMessages.showLoadingDialog(
                  context,
                  message: AppStrings.signingOut.tr(),
                );
              } else {
                context.pop();
                if (state is SignOutErrorState) {
                  AppMessages.showErrorMessage(
                    context,
                    state.error,
                    state.errorType,
                  );
                }
                if (state is SignOutSuccessState) {
                  if (!context.mounted) return;
                  AppMessages.showSuccessMessage(
                    context,
                    AppStrings.signedOutSuccessfully.tr(),
                  );
                  context.read<UserBloc>().add(const LogoutEvent());
                  if (context.read<UserBloc>().state.savedUsers.isNotEmpty) {
                    context.pushReplacementNamed(AppRoutes.accounts);
                    return;
                  }
                  context.pushReplacementNamed(AppRoutes.auth);
                }
              }
            },
            child: IconButton(
              onPressed: () => _signOut(context),
              icon: const Icon(
                HugeIcons.strokeRoundedLogout02,
                color: Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }

  void _goToProfile(BuildContext context) =>
      context.pushNamed(AppRoutes.profile, arguments: 'user-image-settings');

  void _signOut(BuildContext context) async {
    final bool? confirm = await AppMessages.showConfirmDialog(
      context,
      message: AppStrings.signOutConfirmation.tr(),
      confirmIsDanger: true,
    );

    if (confirm == null || !confirm) return;
    if (!context.mounted) return;

    context.read<SignOutBloc>().add(const SignOutEventStarted());
  }
}

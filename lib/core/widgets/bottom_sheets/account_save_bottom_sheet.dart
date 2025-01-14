import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/core/widgets/avatars/user_avatar.dart';
import 'package:your_chef/core/widgets/buttons/custom_icon_button.dart';
import 'package:your_chef/core/widgets/buttons/primary_button.dart';
import 'package:your_chef/features/auth/domain/entities/saved_user.dart';
import 'package:your_chef/common/blocs/user/user_bloc.dart';

class AccountSaveBottomSheet extends StatelessWidget {
  final SavedUser savedUser;
  const AccountSaveBottomSheet({
    super.key,
    required this.savedUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0).r,
      child: BlocConsumer<UserBloc, UserState>(
        listenWhen: (oldState, newState) {
          return newState.status != RequestStatus.loading &&
              oldState.status != newState.status &&
              oldState.savedUsers == newState.savedUsers;
        },
        listener: (context, state) {
          if (state.status == RequestStatus.failure) {
            AppMessages.showErrorMessage(
              context,
              state.error,
              state.errorType,
            );
            // if (!context.canPop()) return;
            context.pop();
          }
          if (state.status == RequestStatus.success) {
            AppMessages.showSuccessMessage(
              context,
              AppStrings.accountSaved.tr(),
            );
            // if (!context.canPop()) return;
            context.pop();
          }
        },
        builder: (context, userState) {
          return PopScope(
            canPop: userState.status != RequestStatus.loading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: CustomIconButton(
                    icon: const Icon(Icons.close),
                    onPressed: userState.status == RequestStatus.loading
                        ? null
                        : () => context.pop(),
                  ),
                ),
                10.height,
                Text(
                  AppStrings.saveAccountMessage.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                20.height,
                ListTile(
                  leading: UserAvatar(url: userState.user!.image),
                  title: Text(userState.user!.name),
                  subtitle: Text(userState.user!.email),
                ),
                20.height,
                PrimaryButton(
                  text: AppStrings.save.tr(),
                  loading: userState.status == RequestStatus.loading,
                  onPressed: () {
                    context.read<UserBloc>().add(SaveUserEvent(savedUser));
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

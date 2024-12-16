import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/widgets/avatars/user_avatar.dart';
import 'package:your_chef/core/widgets/buttons/secondary_button.dart';
import 'package:your_chef/features/user/domain/entities/saved_user.dart';
import 'package:your_chef/features/user/presentation/bloc/user_bloc.dart';

import '../../../../core/utils/network_helper.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state.status == RequestStatus.loading) {
            AppMessages.showLoadingDialog(context,
                message: AppStrings.justAMoment);
          } else {
            context.pop();
            if (state.status == RequestStatus.success) {
              context.pushReplacementNamed(AppRoutes.home);
              AppMessages.showSuccessMessage(
                  context, AppStrings.loggedInSuccessfully);
            }
            if (state.status == RequestStatus.failure) {
              AppMessages.showErrorMessage(
                  context, state.error, state.errorType);
            }
          }
        },
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0).r,
              child: Column(
                children: [
                  const Spacer(
                    flex: 4,
                  ),
                  Text(
                    AppStrings.chooseAccountToLogin,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 4,
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        final SavedUser savedUser = state.savedUsers[index];
                        return ListTile(
                          leading: UserAvatar(
                            url: savedUser.user.image,
                          ),
                          title: Text(savedUser.user.name),
                          subtitle: Text(savedUser.user.email),
                          onTap: () {
                            context.read<UserBloc>().add(
                                  SwitchUserEvent(savedUser),
                                );
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: state.savedUsers.length,
                    ),
                  ),
                  Flexible(child: 24.height),
                  // const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          endIndent: 10.w,
                          color: Colors.grey.withOpacity(0.5),
                          thickness: 1,
                        ),
                      ),
                      const Text(
                        AppStrings.or,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Expanded(
                        child: Divider(
                          indent: 10.w,
                          color: Colors.grey.withOpacity(0.5),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SecondaryButton(
                    text: AppStrings.loginWithAnotherAccount,
                    onPressed: () {
                      context.pushReplacementNamed(AppRoutes.auth);
                    },
                  ),
                  const Spacer(
                    flex: 4,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

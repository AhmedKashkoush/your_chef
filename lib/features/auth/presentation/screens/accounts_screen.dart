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
import 'package:your_chef/core/widgets/icons/app_logo.dart';
import 'package:your_chef/core/widgets/layout/orientation_widget.dart';
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
              child: OrientationWidget(
                portrait: _AccountsScreenPortrait(
                  savedUsers: state.savedUsers,
                ),
                landscape: _AccountsScreenLandscape(
                  savedUsers: state.savedUsers,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AccountsScreenPortrait extends StatelessWidget {
  final List<SavedUser> savedUsers;
  const _AccountsScreenPortrait({
    required this.savedUsers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const Spacer(),
        const AppLogo(),
        Flexible(child: 14.height),
        Text(
          AppStrings.chooseAccountToLogin,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        Flexible(child: 24.height),
        Expanded(
          flex: 6,
          child: ListView.separated(
            itemBuilder: (context, index) {
              final SavedUser savedUser = savedUsers[index];
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
            itemCount: savedUsers.length,
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
        // const Spacer(),
      ],
    );
  }
}

class _AccountsScreenLandscape extends StatelessWidget {
  final List<SavedUser> savedUsers;
  const _AccountsScreenLandscape({
    required this.savedUsers,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Spacer(),
        const AppLogo(),
        Flexible(child: 12.width),
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppStrings.chooseAccountToLogin,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              Flexible(child: 24.height),
              Expanded(
                flex: 6,
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final SavedUser savedUser = savedUsers[index];
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
                  itemCount: savedUsers.length,
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
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

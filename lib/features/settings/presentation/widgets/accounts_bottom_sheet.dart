import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/utils/messages.dart';

import 'package:your_chef/core/widgets/avatars/user_avatar.dart';
import 'package:your_chef/features/auth/domain/entities/saved_user.dart';
import 'package:your_chef/common/blocs/user/user_bloc.dart';

class AccountsBottomSheet extends StatelessWidget {
  const AccountsBottomSheet({
    super.key,
    required this.savedUsers,
  });

  final List<SavedUser> savedUsers;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: UserAvatar(
                  url: state.user!.image,
                ),
                title: Text(
                  state.user!.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: state.user!.id == state.user?.id
                      ? const TextStyle(fontWeight: FontWeight.bold)
                      : null,
                ),
                subtitle: Text(
                  state.user!.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                tileColor: AppColors.primary.withOpacity(0.6),
                trailing: const Icon(Icons.check),
                onTap: () => context.pop(),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: UserAvatar(
                      url: savedUsers[index].user.image,
                    ),
                    title: Text(
                      savedUsers[index].user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      savedUsers[index].user.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        final bool? confirmed =
                            await AppMessages.showConfirmDialog(
                          context,
                          message: AppStrings.removeAccountConfirmation,
                          content: ListTile(
                            title: Text(
                              savedUsers[index].user.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              savedUsers[index].user.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            leading: Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              clipBehavior: Clip.none,
                              children: [
                                UserAvatar(
                                  url: savedUsers[index].user.image,
                                  radius: 32.r,
                                ),
                                const PositionedDirectional(
                                  bottom: -4,
                                  end: -4,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          confirmIsDanger: true,
                        );
                        if (confirmed == null || !confirmed) return;
                        if (!context.mounted) return;
                        context
                            .read<UserBloc>()
                            .add(DeleteSavedUserEvent(savedUsers[index]));
                        // await UserHelper.deleteSavedAccount(savedUsers[index]);

                        // context.pop();
                      },
                      icon: const Icon(
                        HugeIcons.strokeRoundedDelete01,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () => context.pop(savedUsers[index]),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: savedUsers.length,
              ),
              const Divider(),
              ListTile(
                leading: const Icon(HugeIcons.strokeRoundedUserAdd01),
                title: const Text(AppStrings.addAccount),
                onTap: () {
                  context.pop();
                  context.pushNamed(AppRoutes.auth);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/utils/user_helper.dart';
import 'package:your_chef/core/widgets/avatars/user_avatar.dart';

class AccountsBottomSheet extends StatelessWidget {
  const AccountsBottomSheet({
    super.key,
    required this.savedUsers,
  });

  final List<SavedUser> savedUsers;

  @override
  Widget build(BuildContext context) {
    final List<SavedUser> users = savedUsers
        .where((user) => user.user.id != UserHelper.user!.id)
        .toList();

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: UserAvatar(
              url: UserHelper.user!.image,
            ),
            title: Text(
              UserHelper.user!.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: UserHelper.user!.id == UserHelper.user?.id
                  ? const TextStyle(fontWeight: FontWeight.bold)
                  : null,
            ),
            subtitle: Text(
              UserHelper.user!.email,
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
                  url: users[index].user.image,
                ),
                title: Text(
                  users[index].user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  users[index].user.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  onPressed: () async {
                    final bool? confirmed = await AppMessages.showConfirmDialog(
                      context,
                      message: AppStrings.removeAccountConfirmation,
                      content: ListTile(
                        title: Text(
                          users[index].user.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          users[index].user.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          clipBehavior: Clip.none,
                          children: [
                            UserAvatar(
                              url: users[index].user.image,
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
                    await UserHelper.deleteSavedAccount(users[index]);
                    if (!context.mounted) return;
                    context.pop();
                  },
                  icon: const Icon(
                    HugeIcons.strokeRoundedDelete01,
                    color: Colors.red,
                  ),
                ),
                onTap: () => context.pop(users[index]),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: users.length,
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
  }
}

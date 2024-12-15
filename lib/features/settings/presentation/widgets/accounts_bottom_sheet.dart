import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
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

    //TODO: Remove this line below
    final SavedUser user = savedUsers
        .where((user) => user.user.id == UserHelper.user!.id)
        .toList()
        .first;
    final List<SavedUser> allUsers = [user, ...users];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //TODO: Add current user tile here
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            if (index == allUsers.length) {
              return ListTile(
                leading: const Icon(HugeIcons.strokeRoundedUserAdd01),
                title: const Text(AppStrings.addAccount),
                onTap: () {
                  context.pop();
                  context.pushNamed(AppRoutes.auth);
                },
              );
            }
            return ListTile(
              leading: UserAvatar(
                url: allUsers[index].user.image,
              ),
              title: Text(
                allUsers[index].user.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: allUsers[index].user.id == UserHelper.user?.id
                    ? const TextStyle(fontWeight: FontWeight.bold)
                    : null,
              ),
              subtitle: Text(
                allUsers[index].user.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: allUsers[index].user.id == UserHelper.user?.id
                    ? const TextStyle(fontWeight: FontWeight.bold)
                    : null,
              ),
              tileColor: allUsers[index].user.id == UserHelper.user?.id
                  ? AppColors.primary.withOpacity(0.6)
                  : null,
              trailing: allUsers[index].user.id == UserHelper.user?.id
                  ? const Icon(Icons.check)
                  //TODO: Add delete button for non highlighted users
                  : null,
              onTap: allUsers[index].user.id == UserHelper.user?.id
                  ? () => context.pop()
                  : () => context.pop(allUsers[index]),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: allUsers.length + 1,
        )
      ],
    );
  }
}

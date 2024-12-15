import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/utils/user_helper.dart';

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
    final SavedUser user = savedUsers
        .where((user) => user.user.id == UserHelper.user!.id)
        .toList()
        .first;
    final List<SavedUser> allUsers = [user, ...users];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => ListTile(
            leading: CircleAvatar(
              radius: 24.r,
              backgroundImage:
                  CachedNetworkImageProvider(allUsers[index].user.image),
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
                : null,
            onTap: allUsers[index].user.id == UserHelper.user?.id
                ? () => context.pop()
                : () => context.pop(allUsers[index]),
          ),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: allUsers.length,
        )
      ],
    );
  }
}

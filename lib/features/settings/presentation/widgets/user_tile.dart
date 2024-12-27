import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/widgets/avatars/user_avatar.dart';
import 'package:your_chef/core/widgets/tiles/custom_list_tile.dart';
import 'package:your_chef/common/blocs/user/user_bloc.dart';

class UserTile extends StatelessWidget {
  final void Function() onTap, onSignOut;
  const UserTile({
    super.key,
    required this.onTap,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return CustomListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4).r,
          horizontalTitleGap: 4,
          leading: Hero(
            tag: 'user-image-settings',
            child: UserAvatar(
              url: state.user?.image ?? '',
              radius: 40,
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
          trailing: IconButton(
            onPressed: onSignOut,
            icon: const Icon(
              HugeIcons.strokeRoundedLogout02,
              color: Colors.red,
            ),
          ),
        );
      },
    );
  }
}

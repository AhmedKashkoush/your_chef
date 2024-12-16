import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/widgets/avatars/user_avatar.dart';
import 'package:your_chef/core/widgets/fields/search_field.dart';
import 'package:your_chef/features/user/presentation/bloc/user_bloc.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String profileTag;
  const CustomAppBar({
    super.key,
    required this.profileTag,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return AppBar(
          backgroundColor: Colors.transparent,
          titleSpacing: 8.w,
          title: Row(
            children: [
              Hero(
                tag: widget.profileTag,
                child: UserAvatar(
                  radius: 20,
                  url: state.user?.image ?? '',
                  onTap: () => _goToProfile(context),
                ),
              ),
              10.width,
              const Expanded(
                child: SearchField(
                  readOnly: true,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Badge.count(
                count: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                child: const Icon(HugeIcons.strokeRoundedNotification03),
              ),
            ),
          ],
        );
      },
    );
  }

  void _goToProfile(BuildContext context) => context.pushNamed(
        AppRoutes.profile,
        arguments: widget.profileTag,
      );
}

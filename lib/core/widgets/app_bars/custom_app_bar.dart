import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/widgets/avatars/user_avatar.dart';
import 'package:your_chef/common/blocs/user/user_bloc.dart';
import 'package:your_chef/core/widgets/icons/app_logo.dart';
import 'package:your_chef/core/widgets/texts/logo_text.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String profileTag;
  final bool isLogoHero;
  const CustomAppBar({
    super.key,
    required this.profileTag,
    this.isLogoHero = false,
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
              AppLogo(
                size: 20.r,
                isHero: widget.isLogoHero,
              ),
              10.width,
              LogoText(
                isHero: widget.isLogoHero,
              ),
              // const Expanded(
              //   child: SearchField(
              //     readOnly: true,
              //   ),
              // ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(HugeIcons.strokeRoundedSearch01),
            ),
            IconButton(
              onPressed: () {},
              icon: Badge.count(
                count: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                child: const Icon(HugeIcons.strokeRoundedNotification03),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).r,
              child: Hero(
                tag: widget.profileTag,
                child: UserAvatar(
                  radius: 20,
                  url: state.user?.image ?? '',
                  onTap: () => _goToProfile(context),
                ),
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

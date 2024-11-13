import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/utils/user_helper.dart';
import 'package:your_chef/core/widgets/fields/search_field.dart';
import 'package:your_chef/locator.dart';

import '../../../../core/widgets/avatars/user_avatar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    _load();
    super.initState();
  }

  Future<void> _load() async {
    await Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleSpacing: 8.w,
        title: Row(
          children: [
            UserAvatar(
              radius: 20.r,
              url: UserHelper.user?.image ?? '',
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
            onPressed: () => _signOut(context),
            icon: const Icon(
              HugeIcons.strokeRoundedLogout02,
            ),
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(HugeIcons.strokeRoundedNotification03),
          // ),
        ],
      ),
      body: Skeletonizer(
        enabled: _isLoading,
        containersColor: Theme.of(context).iconTheme.color?.withOpacity(0.1),
        enableSwitchAnimation: true,
        child: RefreshIndicator.adaptive(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            _isLoading = true;
            setState(() {});
            await _load();
          },
          child: ListView(
            padding: const EdgeInsets.all(16.0).r,
            children: [
              Text(
                'Welcome ${UserHelper.user?.name.split(' ').first}! 👋',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              30.height,
              Text(
                "Today's Offer",
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.3),
                  fontWeight: FontWeight.bold,
                ),
              ),
              10.height,
              Container(
                height: 140.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              const Divider(),
              Text(
                "Available Categories",
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.3),
                  fontWeight: FontWeight.bold,
                ),
              ),
              10.height,
              SizedBox(
                height: 100.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (_, __) => 10.width,
                  itemBuilder: (_, index) => Column(
                    children: [
                      Container(
                        width: 64.w,
                        height: 64.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                      5.height,
                      Text(
                        'Title',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Restaurants",
                    style: TextStyle(
                      fontSize: 20.sp,
                      color:
                          Theme.of(context).iconTheme.color?.withOpacity(0.3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All'),
                  ),
                ],
              ),
              SizedBox(
                height: 140.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (_, __) => 10.width,
                  itemBuilder: (_, index) => Container(
                    width: 140.w,
                    height: 140.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Popular Foods",
                    style: TextStyle(
                      fontSize: 20.sp,
                      color:
                          Theme.of(context).iconTheme.color?.withOpacity(0.3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All'),
                  ),
                ],
              ),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                ),
                shrinkWrap: true,
                primary: false,
                itemCount: 4,
                itemBuilder: (_, index) => Container(
                  width: 180.w,
                  height: 180.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signOut(BuildContext context) async {
    await locator<SupabaseClient>().auth.signOut();

    await UserHelper.signOut();
    if (!context.mounted) return;
    AppMessages.showSuccessMessage(context, 'Sign out successful');
    context.pushReplacementNamed(AppRoutes.auth);
  }
}

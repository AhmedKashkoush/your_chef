import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/extensions/media_query_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/widgets/bottom_sheets/account_save_bottom_sheet.dart';
import 'package:your_chef/core/widgets/buttons/cart_button.dart';
import 'package:your_chef/core/widgets/views/persistent_view.dart';
import 'package:your_chef/features/home/presentation/bloc/categories/get_home_categories_bloc.dart';
import 'package:your_chef/features/home/presentation/bloc/offers/get_home_offers_bloc.dart';
import 'package:your_chef/features/home/presentation/bloc/on_a_sale/get_home_on_sale_foods_bloc.dart';
import 'package:your_chef/features/home/presentation/bloc/popular_foods/get_home_popular_foods_bloc.dart';
import 'package:your_chef/features/home/presentation/bloc/restaurants/get_home_restaurants_bloc.dart';
import 'package:your_chef/features/home/presentation/screens/home_screen.dart';
import 'package:your_chef/features/settings/presentation/screens/settings_screen.dart';
import 'package:your_chef/features/auth/domain/entities/saved_user.dart';
import 'package:your_chef/common/blocs/user/user_bloc.dart';
import 'package:your_chef/features/foods/presentation/screens/wishlist_screen.dart';
import 'package:your_chef/locator.dart';

class HomeWrapper extends StatefulWidget {
  final SavedUser? savedUser;
  const HomeWrapper({super.key, this.savedUser});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int _currentIndex = 0;
  final PageController _controller = PageController();
  final List<Widget> _screens = [
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => locator<GetHomeOffersBloc>()
            ..add(
              const GetHomeOffersEventStarted(),
            ),
        ),
        BlocProvider(
          create: (context) => locator<GetHomeCategoriesBloc>()
            ..add(
              const GetHomeCategoriesEventStarted(
                GetCategoriesOptions(),
              ),
            ),
        ),
        BlocProvider(
          create: (context) => locator<GetHomeRestaurantsBloc>()
            ..add(
              const GetHomeRestaurantsEventStarted(),
            ),
        ),
        BlocProvider(
          create: (context) => locator<GetHomePopularFoodsBloc>()
            ..add(
              const GetHomePopularFoodsEventStarted(),
            ),
        ),
        BlocProvider(
          create: (context) => locator<GetHomeOnSaleFoodsBloc>()
            ..add(
              const GetHomeOnSaleFoodsEventStarted(),
            ),
        ),
      ],
      child: const HomeScreen(),
    ),
    const WishlistScreen(),
    const SizedBox(),
    const SizedBox(),
    const SettingsScreen(),
  ];

  final List<IconData> _icons = [
    HugeIcons.strokeRoundedHome03,
    HugeIcons.strokeRoundedFavourite,
    HugeIcons.strokeRoundedShoppingCart01,
    HugeIcons.strokeRoundedWorkHistory,
    HugeIcons.strokeRoundedSetting07,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _showAccountSaveSheet(context),
    );
  }

  void _showAccountSaveSheet(BuildContext context) {
    final UserState state = context.read<UserBloc>().state;
    if (widget.savedUser == null) return;
    if (state.savedUsers
        .any((user) => user.user.id == widget.savedUser?.user.id)) {
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) => AccountSaveBottomSheet(
        savedUser: widget.savedUser!,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (_, __) {
        if (_currentIndex == 0) return;
        _changeIndex(0);
      },
      child: Scaffold(
        extendBody: true,
        body: SafeArea(
          top: false,
          bottom: false,
          child: Stack(
            children: [
              Row(
                children: [
                  if (context.isLandscape)
                    Container(
                      width: 36.w,
                      color: context.theme.colorScheme.surface,
                    ),
                  Expanded(
                    child: PageView(
                      controller: _controller,
                      physics: const NeverScrollableScrollPhysics(),
                      children: _screens
                          .map(
                            (screen) => PersistentView(
                              child: screen,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
              if (context.isLandscape)
                _BottomBarLandscape(
                  icons: _icons,
                  currentIndex: _currentIndex,
                  onTap: _changeIndex,
                ),
            ],
          ),
        ),
        bottomNavigationBar: context.isPortrait
            ? _BottomBarPortrait(
                icons: _icons,
                currentIndex: _currentIndex,
                onTap: _changeIndex,
              )
            : null,
      ),
    );
  }

  void _changeIndex(index) {
    _controller.jumpToPage(index);
    setState(() => _currentIndex = index);
  }
}

class _BottomBarPortrait extends StatelessWidget {
  final void Function(int) onTap;
  const _BottomBarPortrait({
    required List<IconData> icons,
    required int currentIndex,
    required this.onTap,
  })  : _icons = icons,
        _currentIndex = currentIndex;

  final List<IconData> _icons;
  final int _currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0).r,
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _icons.map((icon) {
          int index = _icons.indexOf(icon);
          if (index == 2) {
            return Transform.translate(
              offset: const Offset(0, -16),
              child: CartButton(
                icon: icon,
              ),
            );
          }
          return IconButton(
            onPressed: () => onTap(index),
            icon: Icon(
              icon,
              color: _currentIndex == index ? AppColors.primary : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BottomBarLandscape extends StatelessWidget {
  final void Function(int) onTap;
  const _BottomBarLandscape({
    required List<IconData> icons,
    required int currentIndex,
    required this.onTap,
  })  : _icons = icons,
        _currentIndex = currentIndex;

  final List<IconData> _icons;
  final int _currentIndex;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      child: Container(
        margin: const EdgeInsets.all(12.0).r,
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _icons.map((icon) {
            int index = _icons.indexOf(icon);
            if (index == 2) {
              return Transform.translate(
                offset: const Offset(16, 0),
                child: CartButton(
                  icon: icon,
                ),
              );
            }
            return IconButton(
              onPressed: () => onTap(index),
              icon: Icon(
                icon,
                color: _currentIndex == index ? AppColors.primary : null,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

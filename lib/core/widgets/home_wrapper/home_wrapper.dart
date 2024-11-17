import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/extensions/media_query_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/widgets/views/persistent_view.dart';
import 'package:your_chef/features/home/presentation/bloc/home_bloc.dart';
import 'package:your_chef/features/home/presentation/screens/home_screen.dart';
import 'package:your_chef/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:your_chef/features/settings/presentation/screens/settings_screen.dart';
import 'package:your_chef/locator.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int _currentIndex = 0;
  final PageController _controller = PageController();
  final List<Widget> _screens = [
    BlocProvider(
      create: (context) => locator<HomeBloc>()
        ..add(
          const GetHomeDataEvent(),
        ),
      child: const HomeScreen(),
    ),
    const SizedBox(),
    const SizedBox(),
    const SizedBox(),
    BlocProvider(
      create: (context) => locator<SettingsBloc>(),
      child: const SettingsScreen(),
    ),
  ];

  final List<IconData> _icons = [
    HugeIcons.strokeRoundedHome03,
    HugeIcons.strokeRoundedFavourite,
    HugeIcons.strokeRoundedShoppingCart01,
    HugeIcons.strokeRoundedWorkHistory,
    HugeIcons.strokeRoundedSetting07,
  ];

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
              PageView(
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
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: AppColors.primary,
                child: Icon(icon, color: Colors.white),
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
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: AppColors.primary,
                  child: Icon(icon, color: Colors.white),
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

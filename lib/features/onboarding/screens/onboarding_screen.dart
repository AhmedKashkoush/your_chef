import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/images.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/widgets/buttons/primary_button.dart';
import 'package:your_chef/features/onboarding/widgets/next_button.dart';
import 'package:your_chef/features/onboarding/widgets/onboarding_view.dart';
import 'package:your_chef/features/onboarding/widgets/previous_button.dart';
import 'package:your_chef/features/onboarding/widgets/skip_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  final List<Widget> _views = const [
    OnboardingView(
      image: AppImages.onboarding1,
      title: AppStrings.onboardingTitle1,
      body: AppStrings.onboardingBody1,
    ),
    OnboardingView(
      image: AppImages.onboarding2,
      title: AppStrings.onboardingTitle2,
      body: AppStrings.onboardingBody2,
    ),
    OnboardingView(
      image: AppImages.onboarding3,
      title: AppStrings.onboardingTitle3,
      body: AppStrings.onboardingBody3,
    ),
  ];
  bool _hasEnded = false;
  bool _atStart = true;

  @override
  void initState() {
    _controller.addListener(_pageListener);
    super.initState();
  }

  void _pageListener() {
    if (!_controller.hasClients) return;
    if (_controller.page?.floor() == 0) {
      if (!_atStart) {
        setState(() {
          _atStart = true;
        });
      }
    } else {
      if (_atStart) {
        setState(() {
          _atStart = false;
        });
      }
    }
    if (_controller.page?.floor() == _views.length - 1) {
      if (!_hasEnded) {
        setState(() {
          _hasEnded = true;
        });
      }
    } else {
      if (_hasEnded) {
        setState(() {
          _hasEnded = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          if (!_hasEnded)
            SkipButton(
              onPressed: _skip,
            ),
        ],
      ),
      body: PageView(
        controller: _controller,
        children: _views,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0).r,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_atStart)
              PreviousButton(
                onPressed: _previous,
              ),
            const Spacer(),
            SmoothPageIndicator(
              count: _views.length,
              controller: _controller,
              effect: const ExpandingDotsEffect(
                activeDotColor: AppColors.primary,
                dotHeight: 12,
                dotWidth: 12,
                expansionFactor: 5,
              ),
              onDotClicked: _onDotClicked,
            ),
            const Spacer(),
            if (!_hasEnded)
              NextButton(
                onPressed: _next,
              )
            else
              PrimaryButton(
                text: AppStrings.getStarted,
                onPressed: _getStarted,
              )
          ],
        ),
      ),
    );
  }

  void _skip() {
    context.pushReplacementNamed(AppRoutes.auth);
  }

  void _next() {
    if (!_controller.hasClients) return;
    if (_controller.page?.floor() == _views.length - 1) return;

    _controller.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  void _previous() {
    if (!_controller.hasClients) return;
    if (_controller.page?.floor() == 0) return;
    _controller.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  void _onDotClicked(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  void _getStarted() {
    context.pushReplacementNamed(AppRoutes.auth);
  }
}

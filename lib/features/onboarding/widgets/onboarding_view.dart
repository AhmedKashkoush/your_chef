import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/widgets/layout/orientation_widget.dart';

class OnboardingView extends StatelessWidget {
  final String image, title, body;
  const OnboardingView({
    super.key,
    required this.image,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationWidget(
      portrait: _OnboardingViewPortrait(
        image: image,
        title: title,
        body: body,
      ),
      landscape: _OnboardingViewLandscape(
        image: image,
        title: title,
        body: body,
      ),
    );
  }
}

class _OnboardingViewPortrait extends StatelessWidget {
  final String image, title, body;
  const _OnboardingViewPortrait({
    required this.image,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0).r,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            _ImageWidget(image: image),
            45.height,
            _TitleTextWidget(title: title),
            10.height,
            _BodyTextWidget(body: body),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingViewLandscape extends StatelessWidget {
  final String image, title, body;
  const _OnboardingViewLandscape({
    required this.image,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).r,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Expanded(
            child: _ImageWidget(image: image),
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TitleTextWidget(title: title),
                10.height,
                _BodyTextWidget(body: body),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _BodyTextWidget extends StatelessWidget {
  const _BodyTextWidget({
    required this.body,
  });

  final String body;

  @override
  Widget build(BuildContext context) {
    return Text(
      body,
      textAlign: TextAlign.center,
      style: context.theme.textTheme.bodyMedium?.copyWith(
        color: Colors.grey,
      ),
    );
  }
}

class _TitleTextWidget extends StatelessWidget {
  const _TitleTextWidget({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.theme.textTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }
}

class _ImageWidget extends StatelessWidget {
  const _ImageWidget({
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      height: 250.h,
    );
  }
}

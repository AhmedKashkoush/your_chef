import 'package:flutter/material.dart';
import 'package:your_chef/core/widgets/layout/orientation_widget.dart';

class OnboardingView extends StatelessWidget {
  final String image, title, description;
  const OnboardingView({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationWidget(
      portrait: _OnboardingViewPortrait(
        image: image,
        title: title,
        description: description,
      ),
      landscape: _OnboardingViewLandscape(
        image: image,
        title: title,
        description: description,
      ),
    );
  }
}

class _OnboardingViewPortrait extends StatelessWidget {
  final String image, title, description;
  const _OnboardingViewPortrait({
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _OnboardingViewLandscape extends StatelessWidget {
  final String image, title, description;
  const _OnboardingViewLandscape({
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

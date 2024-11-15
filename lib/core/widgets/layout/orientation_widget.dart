import 'package:flutter/material.dart';

class OrientationWidget extends StatelessWidget {
  final Widget portrait, landscape;
  const OrientationWidget({
    super.key,
    required this.portrait,
    required this.landscape,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (_, orientation) {
      if (orientation == Orientation.portrait) {
        return portrait;
      }
      return landscape;
    });
  }
}

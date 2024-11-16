import 'package:flutter/material.dart';

extension MediaQueryExtension on BuildContext {
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;
  bool get keyboardShown => MediaQuery.of(this).viewInsets.bottom > 0;
}

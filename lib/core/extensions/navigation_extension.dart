import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  void pushNamed(String route,
          {Object? arguments, bool rootNavigator = true}) =>
      Navigator.of(this, rootNavigator: rootNavigator).pushNamed(
        route,
        arguments: arguments,
      );
  void pushReplacementNamed(String route,
          {Object? arguments, bool rootNavigator = true}) =>
      Navigator.of(this, rootNavigator: rootNavigator).pushReplacementNamed(
        route,
        arguments: arguments,
      );

  void pushNamedAndRemoveUntil(String route,
          {Object? arguments, bool rootNavigator = true}) =>
      Navigator.of(this, rootNavigator: rootNavigator).pushNamedAndRemoveUntil(
        route,
        (_) => false,
        arguments: arguments,
      );

  void pop<T extends Object?>([T? result]) => Navigator.of(this).pop();
}

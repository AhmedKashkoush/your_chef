import 'package:flutter/material.dart';
import 'package:your_chef/core/constants/colors.dart';

final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(
    surfaceTint: Colors.transparent,
    surface: Colors.grey.shade300,
    seedColor: AppColors.primary,
  ),
  useMaterial3: true,
);
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  colorScheme: ColorScheme.fromSeed(
    surfaceTint: Colors.transparent,
    surface: Colors.grey.shade900,
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
);

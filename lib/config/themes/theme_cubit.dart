import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/constants/keys.dart';
import 'package:your_chef/core/utils/shared_preferences_helper.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void loadTheme() async {
    final ThemeMode mode = ThemeMode.values.byName(
      SharedPreferencesHelper.get<String>(SharedPrefsKeys.theme) ?? 'system',
    );
    emit(mode);
  }

  void setTheme(ThemeMode theme) {
    if (theme == state) return;
    SharedPreferencesHelper.set<String>(SharedPrefsKeys.theme, theme.name);
    emit(theme);
  }
}

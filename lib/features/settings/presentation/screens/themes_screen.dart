import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/config/themes/theme_cubit.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/widgets/buttons/custom_icon_button.dart';
import 'package:your_chef/core/widgets/tiles/custom_list_tile.dart';

class ThemesScreen extends StatelessWidget {
  const ThemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool darkMode = context.theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(AppStrings.themes.tr()),
        leading: context.canPop()
            ? Padding(
                padding: const EdgeInsets.all(8.0).r,
                child: CustomIconButton(
                  icon: const BackButtonIcon(),
                  onPressed: () => context.pop(),
                ),
              )
            : null,
      ),
      body: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, theme) {
          return ListView(
            padding: const EdgeInsets.all(12).r,
            children: [
              CustomListTile(
                leading: Icon(
                  darkMode
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                ),
                title: Text(AppStrings.system.tr()),
                trailing:
                    theme == ThemeMode.system ? const Icon(Icons.check) : null,
                onTap: () =>
                    context.read<ThemeCubit>().setTheme(ThemeMode.system),
              ),
              10.height,
              CustomListTile(
                leading: const Icon(
                  Icons.light_mode_outlined,
                ),
                title: Text(AppStrings.light.tr()),
                trailing:
                    theme == ThemeMode.light ? const Icon(Icons.check) : null,
                onTap: () =>
                    context.read<ThemeCubit>().setTheme(ThemeMode.light),
              ),
              10.height,
              CustomListTile(
                leading: const Icon(
                  Icons.dark_mode_outlined,
                ),
                title: Text(AppStrings.dark.tr()),
                trailing:
                    theme == ThemeMode.dark ? const Icon(Icons.check) : null,
                onTap: () =>
                    context.read<ThemeCubit>().setTheme(ThemeMode.dark),
              ),
            ],
          );
        },
      ),
    );
  }
}

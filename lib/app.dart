import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:your_chef/config/routes/router.dart';
import 'package:your_chef/config/themes/theme_cubit.dart';
import 'package:your_chef/config/themes/themes.dart';

class YourChefApp extends StatelessWidget {
  const YourChefApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: BlocProvider(
        create: (context) => ThemeCubit()..loadTheme(),
        child: Builder(builder: (context) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: themeMode,
                initialRoute: AppRouter.initialRoute,
                onGenerateRoute: AppRouter.onGenerateRoute,
              );
            },
          );
        }),
      ),
    );
  }
}

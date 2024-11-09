import 'package:flutter/material.dart';
import 'package:your_chef/config/routes/router.dart';
import 'package:your_chef/config/themes/themes.dart';

class YourChefApp extends StatelessWidget {
  const YourChefApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRouter.initialRoute,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

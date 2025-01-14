import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/app.dart';
import 'package:your_chef/config/locales/locales.dart';
import 'package:your_chef/locator.dart';

import 'core/utils/network_helper.dart';
import 'core/utils/shared_preferences_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SharedPreferencesHelper.init();
  NetworkHelper.init();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANNO_KEY']!,
  );
  setupLocator();
  runApp(
    EasyLocalization(
      supportedLocales: AppLocales.supportedLocales,
      path: 'assets/translations',
      fallbackLocale: AppLocales.supportedLocales.first,
      child: const YourChefApp(),
    ),
  );
}

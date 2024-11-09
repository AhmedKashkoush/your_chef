import 'package:flutter/material.dart';
import 'package:your_chef/app.dart';
import 'package:your_chef/locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(
    const YourChefApp(),
  );
}

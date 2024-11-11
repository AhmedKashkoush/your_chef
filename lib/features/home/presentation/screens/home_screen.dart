import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/locator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await locator<SupabaseClient>().auth.signOut();
              if (!context.mounted) return;
              context.pushReplacementNamed(AppRoutes.auth);
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('Home Screen'),
      ),
    );
  }
}

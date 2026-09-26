import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/storage/token_storage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.appName)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('You are signed in 🎉'),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                await sl<TokenStorage>().clear();
                if (context.mounted) context.goNamed(RouteNames.login);
              },
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}

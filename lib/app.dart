import 'package:flutter/material.dart';

import 'core/constants/app_strings.dart';
import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class LimitaApp extends StatelessWidget {
  const LimitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AppRouter appRouter = sl<AppRouter>();

    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter.router,
    );
  }
}

import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'router/app_router.dart';

class TaximanPassengerApp extends StatelessWidget {
  const TaximanPassengerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Taximan Passenger',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}

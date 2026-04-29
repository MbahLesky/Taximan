import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/services/shared_preferences_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();

  try {
    await Firebase.initializeApp();
  } catch (error) {
    // TODO: Add Firebase config files before enabling backend features:
    // Android: android/app/google-services.json
    // iOS: ios/Runner/GoogleService-Info.plist
    if (kDebugMode) {
      debugPrint('Firebase not configured yet: $error');
    }
  }

  runApp(const ProviderScope(child: TaximanPassengerApp()));
}

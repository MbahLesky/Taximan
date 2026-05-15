import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/services/shared_preferences_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // Allow the app to run even if the local .env file is missing.
    // This is useful for CI/build servers or when the file is intentionally excluded.
    debugPrint('Warning: .env file not found or failed to load: $e');
  }

  await SharedPreferencesService.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: TaximanPassengerApp()));
}

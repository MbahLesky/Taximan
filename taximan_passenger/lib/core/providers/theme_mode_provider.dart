import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/shared_preferences_service.dart';

const _themeModeKey = 'theme_is_dark';

class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController() : super(_loadInitialThemeMode());

  static ThemeMode _loadInitialThemeMode() {
    final isDark = SharedPreferencesService.getBool(_themeModeKey) ?? false;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await SharedPreferencesService.setBool(_themeModeKey, mode == ThemeMode.dark);
  }

  Future<void> toggleThemeMode() async {
    await setThemeMode(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeController, ThemeMode>((ref) {
  return ThemeModeController();
});

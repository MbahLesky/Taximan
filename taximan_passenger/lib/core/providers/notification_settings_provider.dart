import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/shared_preferences_service.dart';

const _notificationsEnabledKey = 'notifications_enabled';

class NotificationSettings {
  final bool enabled;

  const NotificationSettings({this.enabled = true});

  NotificationSettings copyWith({bool? enabled}) {
    return NotificationSettings(enabled: enabled ?? this.enabled);
  }
}

class NotificationSettingsController extends StateNotifier<NotificationSettings> {
  NotificationSettingsController() : super(_loadInitialSettings());

  static NotificationSettings _loadInitialSettings() {
    final enabled = SharedPreferencesService.getBool(_notificationsEnabledKey);
    return NotificationSettings(enabled: enabled ?? true);
  }

  Future<void> setEnabled(bool enabled) async {
    state = state.copyWith(enabled: enabled);
    await SharedPreferencesService.setBool(_notificationsEnabledKey, enabled);
  }

  Future<void> toggleEnabled() async {
    await setEnabled(!state.enabled);
  }
}

final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsController, NotificationSettings>(
  (ref) => NotificationSettingsController(),
);

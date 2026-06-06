import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/shared_preferences_service.dart';

const _driverPaymentPinKey = 'driver_payment_pin';

final driverPaymentPinProvider = FutureProvider<String?>((ref) async {
  final storedPin = SharedPreferencesService.getString(_driverPaymentPinKey);
  if (storedPin == null || storedPin.isEmpty) {
    return null;
  }
  return storedPin;
});

Future<bool> saveDriverPaymentPin(String pin) {
  return SharedPreferencesService.setString(_driverPaymentPinKey, pin);
}

Future<bool> clearDriverPaymentPin() {
  return SharedPreferencesService.setString(_driverPaymentPinKey, '');
}

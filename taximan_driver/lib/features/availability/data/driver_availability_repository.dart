import 'package:cloud_firestore/cloud_firestore.dart';

class DriverAvailabilityRepository {
  DriverAvailabilityRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> setOnline({
    required String driverId,
    required bool isOnline,
  }) async {
    final driverRef = _firestore.collection('drivers').doc(driverId);
    final locationRef = _firestore.collection('driver_locations').doc(driverId);

    await _firestore.runTransaction((transaction) async {
      final driverSnapshot = await transaction.get(driverRef);
      final driverData = driverSnapshot.data();
      if (driverData == null) {
        throw Exception('Driver profile was not found.');
      }
      final verificationStatus =
          (driverData['verificationStatus'] as String? ?? '').toLowerCase();
      if (isOnline && verificationStatus != 'approved') {
        throw Exception('Approval is required before going online.');
      }

      final availabilityStatus = isOnline ? 'online' : 'offline';
      transaction.set(driverRef, {
        'availabilityStatus': availabilityStatus,
        'isAvailable': isOnline,
        'presence': {
          'isOnline': isOnline,
          'lastChangedAt': FieldValue.serverTimestamp(),
        },
        'lastSeenAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      transaction.set(locationRef, {
        'driverId': driverId,
        'isOnline': isOnline,
        'isAvailable': isOnline,
        'activeTripId': driverData['activeTripId'],
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }

  Future<void> setBusy({required String driverId, required bool isBusy}) async {
    final status = isBusy ? 'busy' : 'online';
    await _firestore.collection('drivers').doc(driverId).set({
      'availabilityStatus': status,
      'isAvailable': !isBusy,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await _firestore.collection('driver_locations').doc(driverId).set({
      'driverId': driverId,
      'isOnline': true,
      'isAvailable': !isBusy,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> saveSchedule({
    required String driverId,
    required List<AvailabilityScheduleEntry> schedule,
  }) {
    return _firestore.collection('drivers').doc(driverId).set({
      'availabilitySchedule': schedule.map((entry) => entry.toMap()).toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}

class AvailabilityScheduleEntry {
  const AvailabilityScheduleEntry({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  final String day;
  final String startTime;
  final String endTime;

  Map<String, String> toMap() {
    return {'day': day, 'startTime': startTime, 'endTime': endTime};
  }
}

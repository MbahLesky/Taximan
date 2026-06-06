import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class DriverLocationService {
  DriverLocationService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  StreamSubscription<Position>? _positionSubscription;
  String? _driverId;

  Future<void> startUpdating({required String driverId, int distanceFilterMeters = 10}) async {
    if (_positionSubscription != null) return;
    _driverId = driverId;

    await _ensureLocationPermission();

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: distanceFilterMeters,
      ),
    ).listen((position) async {
      try {
        await _firestore.collection('driver_locations').doc(driverId).set({
          'driverId': driverId,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'heading': position.heading,
          'speed': position.speed,
          'isOnline': true,
          'isAvailable': true,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (_) {
        // swallow write errors; consumer can listen to warnings elsewhere
      }
    });
  }

  Future<void> stopUpdating() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    _driverId = null;
  }

  Future<void> _ensureLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied.');
    }
  }
}

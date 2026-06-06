import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../shared/models/app_location.dart';
import '../../../shared/models/driver.dart';
import '../../../shared/models/driver_location.dart';

class LocationAccessException implements Exception {
  const LocationAccessException({
    required this.permissionStatus,
    required this.message,
  });

  final String permissionStatus;
  final String message;

  @override
  String toString() => message;
}

class LocationRepository {
  LocationRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const _driversCollection = 'drivers';
  static const _fallbackCity = 'Bamenda';
  static const _fallbackState = 'North West';
  static const _fallbackCountry = 'Cameroon';

  Future<AppLocation> getCurrentLocation() async {
    await ensureLocationAccess();
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
    return reverseGeocode(
      position.latitude,
      position.longitude,
      source: 'gps',
      fallbackName: 'Current location',
    );
  }

  Stream<AppLocation> streamDeviceLocation() async* {
    await ensureLocationAccess();
    yield* Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 15,
      ),
    ).map(_positionToLiveLocation);
  }

  Future<String> ensureLocationAccess() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationAccessException(
        permissionStatus: 'serviceDisabled',
        message: 'Turn on device location services to use the map.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final status = _permissionStatus(permission);
    if (status != 'granted') {
      throw LocationAccessException(
        permissionStatus: status,
        message: status == 'deniedForever'
            ? 'Location permission is permanently denied. Enable it in app settings.'
            : 'Allow location permission to detect your pickup point.',
      );
    }

    return status;
  }

  Future<String> checkPermissionStatus() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'serviceDisabled';
    }
    return _permissionStatus(await Geolocator.checkPermission());
  }

  Future<AppLocation> reverseGeocode(
    double latitude,
    double longitude, {
    String source = 'map_pin',
    String fallbackName = 'Pinned location',
  }) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        return _placemarkToLocation(
          placemarks.first,
          latitude: latitude,
          longitude: longitude,
          source: source,
          fallbackName: fallbackName,
        );
      }
    } catch (_) {
      // Geocoding can fail when the platform geocoder is unavailable; the
      // coordinates are still valid and usable for booking/tracking.
    }

    return _fallbackLocation(
      latitude,
      longitude,
      source: source,
      fallbackName: fallbackName,
    );
  }

  Future<List<AppLocation>> searchLocations(
    String query, {
    int limit = 4,
  }) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      final geocodedLocations = await locationFromAddress(query);
      final results = <AppLocation>[];
      for (final item in geocodedLocations.take(limit)) {
        results.add(
          await reverseGeocode(
            item.latitude,
            item.longitude,
            source: 'search',
            fallbackName: query,
          ),
        );
      }
      return results;
    } catch (_) {
      return [];
    }
  }

  Stream<List<DriverLocation>> streamOnlineDriverLocations({int limit = 50}) {
    return _firestore
        .collection(_driversCollection)
        .where('isAvailable', isEqualTo: true)
        .where('availabilityStatus', isEqualTo: 'online')
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) {
                final data = doc.data();
                return _locationFromDriverData(doc.id, data);
              })
              .whereType<DriverLocation>()
              .where(_hasUsableDriverCoordinates)
              .toList();
        });
  }

  Stream<DriverLocation?> streamAssignedDriverLocation(String driverId) {
    if (driverId.isEmpty) {
      return Stream<DriverLocation?>.value(null);
    }

    return _firestore
        .collection(_driversCollection)
        .doc(driverId)
        .snapshots()
        .map((doc) {
          if (!doc.exists) {
            return null;
          }
          final data = doc.data();
          if (data == null) {
            return null;
          }
          return _locationFromDriverData(doc.id, data);
        });
  }

  DriverLocation? _locationFromDriverData(String driverId, Map<String, dynamic> data) {
    final driver = Driver.fromMap({
      'id': driverId,
      ...data,
    });
    final location = driver.currentLocation;
    if (location == null || !location.hasCoordinates) {
      return null;
    }
    return DriverLocation(
      driverId: driver.id,
      latitude: location.latitude!,
      longitude: location.longitude!,
      isOnline: driver.availabilityStatus.toLowerCase() == 'online',
      isAvailable: driver.isAvailable,
      updatedAt: location.updatedAt,
    );
  }

  AppLocation _positionToLiveLocation(Position position) {
    return AppLocation(
      name: 'Current location',
      address: 'Current location',
      city: _fallbackCity,
      state: _fallbackState,
      country: _fallbackCountry,
      latitude: position.latitude,
      longitude: position.longitude,
      source: 'gps_live',
      updatedAt: DateTime.now(),
    );
  }

  AppLocation _placemarkToLocation(
    Placemark placemark, {
    required double latitude,
    required double longitude,
    required String source,
    required String fallbackName,
  }) {
    final city = _firstNonEmpty([
      placemark.locality,
      placemark.subAdministrativeArea,
      _fallbackCity,
    ]);
    final state = _firstNonEmpty([
      placemark.administrativeArea,
      _fallbackState,
    ]);
    final country = _firstNonEmpty([placemark.country, _fallbackCountry]);
    final name = _firstNonEmpty([
      placemark.name,
      placemark.street,
      placemark.subLocality,
      fallbackName,
    ]);
    final addressParts = _dedupe([
      placemark.street,
      placemark.subLocality,
      city,
      country,
    ]);
    final address = addressParts.isEmpty
        ? _coordinateLabel(fallbackName, latitude, longitude)
        : addressParts.join(', ');

    return AppLocation(
      name: name,
      address: address,
      landmarkType: 'map_pin',
      city: city,
      state: state,
      country: country,
      latitude: latitude,
      longitude: longitude,
      source: source,
      updatedAt: DateTime.now(),
    );
  }

  AppLocation _fallbackLocation(
    double latitude,
    double longitude, {
    required String source,
    required String fallbackName,
  }) {
    return AppLocation(
      name: fallbackName,
      address: _coordinateLabel(fallbackName, latitude, longitude),
      landmarkType: 'map_pin',
      city: _fallbackCity,
      state: _fallbackState,
      country: _fallbackCountry,
      latitude: latitude,
      longitude: longitude,
      source: source,
      updatedAt: DateTime.now(),
    );
  }

  String _permissionStatus(LocationPermission permission) {
    return switch (permission) {
      LocationPermission.always || LocationPermission.whileInUse => 'granted',
      LocationPermission.denied => 'denied',
      LocationPermission.deniedForever => 'deniedForever',
      LocationPermission.unableToDetermine => 'unknown',
    };
  }

  bool _hasUsableDriverCoordinates(DriverLocation location) {
    return location.latitude != 0 && location.longitude != 0;
  }

  String _coordinateLabel(String label, double latitude, double longitude) {
    return '$label (${latitude.toStringAsFixed(5)}, '
        '${longitude.toStringAsFixed(5)})';
  }

  String _firstNonEmpty(List<String?> values) {
    return values
        .map((value) => value?.trim() ?? '')
        .firstWhere((value) => value.isNotEmpty);
  }

  List<String> _dedupe(List<String?> values) {
    final seen = <String>{};
    final result = <String>[];
    for (final rawValue in values) {
      final value = rawValue?.trim();
      if (value == null || value.isEmpty) {
        continue;
      }
      final key = value.toLowerCase();
      if (seen.add(key)) {
        result.add(value);
      }
    }
    return result;
  }
}

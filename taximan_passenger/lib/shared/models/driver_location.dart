import 'model_helpers.dart';

class DriverLocation {
  const DriverLocation({
    required this.driverId,
    required this.latitude,
    required this.longitude,
    this.heading = 0,
    this.speed = 0,
    this.isOnline = false,
    this.isAvailable = false,
    this.activeTripId,
    this.updatedAt,
  });

  final String driverId;
  final double latitude;
  final double longitude;
  final double heading;
  final double speed;
  final bool isOnline;
  final bool isAvailable;
  final String? activeTripId;
  final DateTime? updatedAt;

  DriverLocation copyWith({
    String? driverId,
    double? latitude,
    double? longitude,
    double? heading,
    double? speed,
    bool? isOnline,
    bool? isAvailable,
    String? activeTripId,
    DateTime? updatedAt,
  }) {
    return DriverLocation(
      driverId: driverId ?? this.driverId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      heading: heading ?? this.heading,
      speed: speed ?? this.speed,
      isOnline: isOnline ?? this.isOnline,
      isAvailable: isAvailable ?? this.isAvailable,
      activeTripId: activeTripId ?? this.activeTripId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'driverId': driverId,
      'latitude': latitude,
      'longitude': longitude,
      'heading': heading,
      'speed': speed,
      'isOnline': isOnline,
      'isAvailable': isAvailable,
      'activeTripId': activeTripId,
      'updatedAt': writeDateTime(updatedAt),
    };
  }

  factory DriverLocation.fromMap(Map<String, dynamic> map) {
    return DriverLocation(
      driverId: map['driverId'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
      heading: (map['heading'] as num?)?.toDouble() ?? 0,
      speed: (map['speed'] as num?)?.toDouble() ?? 0,
      isOnline: map['isOnline'] as bool? ?? false,
      isAvailable: map['isAvailable'] as bool? ?? false,
      activeTripId: map['activeTripId'] as String?,
      updatedAt: readDateTime(map['updatedAt']),
    );
  }
}

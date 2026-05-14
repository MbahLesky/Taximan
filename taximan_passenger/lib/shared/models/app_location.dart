import 'model_helpers.dart';

class AppLocation {
  const AppLocation({
    required this.address,
    this.latitude,
    this.longitude,
    this.placeId,
    this.updatedAt,
  });

  final String address;
  final double? latitude;
  final double? longitude;
  final String? placeId;
  final DateTime? updatedAt;

  bool get hasCoordinates => latitude != null && longitude != null;

  AppLocation copyWith({
    String? address,
    double? latitude,
    double? longitude,
    String? placeId,
    DateTime? updatedAt,
  }) {
    return AppLocation(
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      placeId: placeId ?? this.placeId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'placeId': placeId,
      'updatedAt': writeDateTime(updatedAt),
    };
  }

  factory AppLocation.fromMap(Map<String, dynamic> map) {
    return AppLocation(
      address: map['address'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      placeId: map['placeId'] as String?,
      updatedAt: readDateTime(map['updatedAt']),
    );
  }

  static AppLocation fromValue(Object? value) {
    if (value is AppLocation) {
      return value;
    }
    if (value is Map<String, dynamic>) {
      return AppLocation.fromMap(value);
    }
    if (value is Map) {
      return AppLocation.fromMap(Map<String, dynamic>.from(value));
    }
    return AppLocation(address: value as String? ?? '');
  }
}

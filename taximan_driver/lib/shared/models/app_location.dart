class AppLocation {
  const AppLocation({
    required this.address,
    this.latitude,
    this.longitude,
  });

  final String address;
  final double? latitude;
  final double? longitude;

  bool get hasCoordinates => latitude != null && longitude != null;

  String get displayName => address.isNotEmpty ? address : 'Unknown location';

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{'address': address};
    if (latitude != null && longitude != null) {
      data['latitude'] = latitude;
      data['longitude'] = longitude;
    }
    return data;
  }

  AppLocation copyWith({
    String? address,
    double? latitude,
    double? longitude,
  }) {
    return AppLocation(
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory AppLocation.fromValue(Object? value) {
    if (value is String) {
      return AppLocation(address: value);
    }
    if (value is Map<String, dynamic>) {
      final address = (value['address'] ?? value['name'] ?? '').toString();
      final latitude = _parseDouble(value['latitude'] ?? value['lat']);
      final longitude = _parseDouble(value['longitude'] ?? value['lng'] ?? value['long']);
      return AppLocation(
        address: address.isNotEmpty ? address : 'Location',
        latitude: latitude,
        longitude: longitude,
      );
    }
    if (value is Map) {
      final address = (value['address'] ?? value['name'] ?? '').toString();
      final latitude = _parseDouble(value['latitude'] ?? value['lat']);
      final longitude = _parseDouble(value['longitude'] ?? value['lng'] ?? value['long']);
      return AppLocation(
        address: address.isNotEmpty ? address : 'Location',
        latitude: latitude,
        longitude: longitude,
      );
    }
    return const AppLocation(address: 'Unknown location');
  }
}

double? _parseDouble(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is double) {
    return value;
  }
  if (value is int) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

import 'model_helpers.dart';

class AppLocation {
  const AppLocation({
    required this.address,
    this.name,
    this.city = 'Bamenda',
    this.state = 'North West',
    this.country = 'Cameroon',
    this.latitude,
    this.longitude,
    this.placeId,
    this.source = 'preset',
    this.updatedAt,
  });

  final String? name;
  final String address;
  final String city;
  final String state;
  final String country;
  final double? latitude;
  final double? longitude;
  final String? placeId;
  final String source;
  final DateTime? updatedAt;

  bool get hasCoordinates => latitude != null && longitude != null;
  String get displayName => name?.isNotEmpty == true ? name! : address;
  String get fullAddress {
    final normalizedAddress = address.toLowerCase();
    if (normalizedAddress.contains(city.toLowerCase()) &&
        normalizedAddress.contains(country.toLowerCase())) {
      return address;
    }
    final parts = [
      address,
      city,
      country,
    ].where((part) => part.trim().isNotEmpty).toList();
    return parts.join(', ');
  }

  AppLocation copyWith({
    String? name,
    String? address,
    String? city,
    String? state,
    String? country,
    double? latitude,
    double? longitude,
    String? placeId,
    String? source,
    DateTime? updatedAt,
  }) {
    return AppLocation(
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      placeId: placeId ?? this.placeId,
      source: source ?? this.source,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'placeId': placeId,
      'source': source,
      'updatedAt': writeDateTime(updatedAt),
    };
  }

  factory AppLocation.fromMap(Map<String, dynamic> map) {
    return AppLocation(
      name: map['name'] as String?,
      address: map['address'] as String? ?? '',
      city: map['city'] as String? ?? 'Bamenda',
      state: map['state'] as String? ?? 'North West',
      country: map['country'] as String? ?? 'Cameroon',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      placeId: map['placeId'] as String?,
      source: map['source'] as String? ?? 'preset',
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
    final address = value as String? ?? '';
    return AppLocation(address: address, name: address, source: 'typed');
  }
}

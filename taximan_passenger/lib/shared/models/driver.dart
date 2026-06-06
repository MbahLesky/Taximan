import 'app_location.dart';
import 'model_helpers.dart';
import 'vehicle.dart';

class Driver {
  const Driver({
    required this.id,
    required this.fullName,
    required this.rating,
    required this.vehicle,
    required this.arrivalEta,
    this.email = '',
    this.phone = '',
    this.profilePhotoUrl,
    this.role = 'driver',
    this.verificationStatus = 'approved',
    this.availabilityStatus = 'online',
    this.isAvailable = true,
    this.isActive = true,
    this.ratingCount = 0,
    this.currentLocation,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String fullName;
  final double rating;
  final Vehicle vehicle;
  final String arrivalEta;
  final String email;
  final String phone;
  final String? profilePhotoUrl;
  final String role;
  final String verificationStatus;
  final String availabilityStatus;
  final bool isAvailable;
  final bool isActive;
  final int ratingCount;
  final AppLocation? currentLocation;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Driver copyWith({
    String? id,
    String? fullName,
    double? rating,
    Vehicle? vehicle,
    String? arrivalEta,
    String? email,
    String? phone,
    String? profilePhotoUrl,
    String? role,
    String? verificationStatus,
    String? availabilityStatus,
    bool? isAvailable,
    bool? isActive,
    int? ratingCount,
    AppLocation? currentLocation,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Driver(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      rating: rating ?? this.rating,
      vehicle: vehicle ?? this.vehicle,
      arrivalEta: arrivalEta ?? this.arrivalEta,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      role: role ?? this.role,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      isAvailable: isAvailable ?? this.isAvailable,
      isActive: isActive ?? this.isActive,
      ratingCount: ratingCount ?? this.ratingCount,
      currentLocation: currentLocation ?? this.currentLocation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'profilePhotoUrl': profilePhotoUrl,
      'role': role,
      'verificationStatus': verificationStatus,
      'availabilityStatus': availabilityStatus,
      'isAvailable': isAvailable,
      'isActive': isActive,
      'rating': rating,
      'ratingAverage': rating,
      'ratingCount': ratingCount,
      'vehicle': vehicle.toMap(),
      'arrivalEta': arrivalEta,
      'currentLocation': currentLocation?.toMap(),
      'createdAt': writeDateTime(createdAt),
      'updatedAt': writeDateTime(updatedAt),
    };
  }

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      id: map['id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      rating:
          (map['ratingAverage'] as num?)?.toDouble() ??
          (map['rating'] as num?)?.toDouble() ??
          0,
      vehicle: Vehicle.fromMap(map['vehicle'] as Map<String, dynamic>?),
      arrivalEta: map['arrivalEta'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      profilePhotoUrl: map['profilePhotoUrl'] as String?,
      role: map['role'] as String? ?? 'driver',
      verificationStatus: map['verificationStatus'] as String? ?? 'pending',
      availabilityStatus: map['availabilityStatus'] as String? ?? 'offline',
      isAvailable: map['isAvailable'] as bool? ?? false,
      isActive: map['isActive'] as bool? ?? true,
      ratingCount: (map['ratingCount'] as num?)?.toInt() ?? 0,
      currentLocation: map['currentLocation'] == null
          ? null
          : AppLocation.fromValue(map['currentLocation']),
      createdAt: readDateTime(map['createdAt']),
      updatedAt: readDateTime(map['updatedAt']),
    );
  }
}

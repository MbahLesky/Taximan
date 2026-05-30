import 'model_helpers.dart';
import 'vehicle.dart';

class DriverModel {
  const DriverModel({
    required this.id,
    required this.email,
    required this.phone,
    this.fullName = '',
    this.city = '',
    this.profilePhotoUrl,
    this.role = 'driver',
    this.verificationStatus = 'pending',
    this.availabilityStatus = 'offline',
    this.isAvailable = false,
    this.isActive = true,
    this.ratingAverage = 0,
    this.ratingCount = 0,
    this.vehicleId,
    this.vehicle,
    this.documentUrls = const {},
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String city;
  final String? profilePhotoUrl;
  final String role;
  final String verificationStatus;
  final String availabilityStatus;
  final bool isAvailable;
  final bool isActive;
  final double ratingAverage;
  final int ratingCount;
  final String? vehicleId;
  final Vehicle? vehicle;
  final Map<String, String> documentUrls;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DriverModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? city,
    String? profilePhotoUrl,
    String? role,
    String? verificationStatus,
    String? availabilityStatus,
    bool? isAvailable,
    bool? isActive,
    double? ratingAverage,
    int? ratingCount,
    String? vehicleId,
    Vehicle? vehicle,
    Map<String, String>? documentUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DriverModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      role: role ?? this.role,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      isAvailable: isAvailable ?? this.isAvailable,
      isActive: isActive ?? this.isActive,
      ratingAverage: ratingAverage ?? this.ratingAverage,
      ratingCount: ratingCount ?? this.ratingCount,
      vehicleId: vehicleId ?? this.vehicleId,
      vehicle: vehicle ?? this.vehicle,
      documentUrls: documentUrls ?? this.documentUrls,
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
      'city': city,
      'profilePhotoUrl': profilePhotoUrl,
      'role': role,
      'verificationStatus': verificationStatus,
      'availabilityStatus': availabilityStatus,
      'isAvailable': isAvailable,
      'isActive': isActive,
      'ratingAverage': ratingAverage,
      'ratingCount': ratingCount,
      'vehicleId': vehicleId,
      'vehicle': vehicle?.toMap(),
      'documentUrls': documentUrls,
      'createdAt': writeDateTime(createdAt),
      'updatedAt': writeDateTime(updatedAt),
    };
  }

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    final documentUrls = (map['documentUrls'] as Map<String, dynamic>?) ?? {};
    final vehicleMap = map['vehicle'] as Map<String, dynamic>?;
    final ratingValue = map['ratingAverage'] ?? map['rating'];

    return DriverModel(
      id: map['id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      city: map['city'] as String? ?? '',
      profilePhotoUrl: map['profilePhotoUrl'] as String?,
      role: map['role'] as String? ?? 'driver',
      verificationStatus: map['verificationStatus'] as String? ?? 'pending',
      availabilityStatus: map['availabilityStatus'] as String? ?? 'offline',
      isAvailable: map['isAvailable'] as bool? ?? false,
      isActive: map['isActive'] as bool? ?? true,
      ratingAverage: (ratingValue as num?)?.toDouble() ?? 0,
      ratingCount: (map['ratingCount'] as num?)?.toInt() ?? 0,
      vehicleId: map['vehicleId'] as String?,
      vehicle: vehicleMap == null ? null : Vehicle.fromMap(vehicleMap),
      documentUrls: documentUrls.map(
        (key, value) => MapEntry(key, value?.toString() ?? ''),
      ),
      createdAt: readDateTime(map['createdAt']),
      updatedAt: readDateTime(map['updatedAt']),
    );
  }
}

import 'model_helpers.dart';

class User {
  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.homeLocation,
    this.profilePhotoUrl,
    this.role = 'passenger',
    this.isActive = true,
    this.defaultPaymentMethod = 'cash',
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String homeLocation;
  final String? profilePhotoUrl;
  final String role;
  final bool isActive;
  final String defaultPaymentMethod;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? homeLocation,
    String? profilePhotoUrl,
    String? role,
    bool? isActive,
    String? defaultPaymentMethod,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      homeLocation: homeLocation ?? this.homeLocation,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      defaultPaymentMethod: defaultPaymentMethod ?? this.defaultPaymentMethod,
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
      'homeLocation': homeLocation,
      'profilePhotoUrl': profilePhotoUrl,
      'role': role,
      'isActive': isActive,
      'defaultPaymentMethod': defaultPaymentMethod,
      'createdAt': writeDateTime(createdAt),
      'updatedAt': writeDateTime(updatedAt),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      homeLocation: map['homeLocation'] as String? ?? '',
      profilePhotoUrl: map['profilePhotoUrl'] as String?,
      role: map['role'] as String? ?? 'passenger',
      isActive: map['isActive'] as bool? ?? true,
      defaultPaymentMethod: map['defaultPaymentMethod'] as String? ?? 'cash',
      createdAt: readDateTime(map['createdAt']),
      updatedAt: readDateTime(map['updatedAt']),
    );
  }
}

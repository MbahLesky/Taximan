import 'vehicle.dart';

class Driver {
  const Driver({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.city,
    required this.rating,
    required this.verificationStatus,
    required this.vehicle,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String city;
  final double rating;
  final String verificationStatus;
  final Vehicle vehicle;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'city': city,
      'rating': rating,
      'verificationStatus': verificationStatus,
      'vehicle': vehicle.toMap(),
    };
  }

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      id: map['id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      city: map['city'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      verificationStatus: map['verificationStatus'] as String? ?? '',
      vehicle: Vehicle.fromMap(
        (map['vehicle'] as Map<String, dynamic>?) ?? const {},
      ),
    );
  }
}

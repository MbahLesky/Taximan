class User {
  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.homeLocation,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String homeLocation;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'homeLocation': homeLocation,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      homeLocation: map['homeLocation'] as String? ?? '',
    );
  }
}

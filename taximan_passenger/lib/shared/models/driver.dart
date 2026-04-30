class Driver {
  const Driver({
    required this.id,
    required this.fullName,
    required this.rating,
    required this.vehicle,
    required this.plateNumber,
    required this.arrivalEta,
  });

  final String id;
  final String fullName;
  final double rating;
  final String vehicle;
  final String plateNumber;
  final String arrivalEta;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'rating': rating,
      'vehicle': vehicle,
      'plateNumber': plateNumber,
      'arrivalEta': arrivalEta,
    };
  }

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      id: map['id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      vehicle: map['vehicle'] as String? ?? '',
      plateNumber: map['plateNumber'] as String? ?? '',
      arrivalEta: map['arrivalEta'] as String? ?? '',
    );
  }
}

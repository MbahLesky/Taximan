class Vehicle {
  const Vehicle({
    required this.type,
    required this.model,
    required this.plateNumber,
    required this.color,
    required this.capacity,
  });

  final String type;
  final String model;
  final String plateNumber;
  final String color;
  final int capacity;

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'model': model,
      'plateNumber': plateNumber,
      'color': color,
      'capacity': capacity,
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      type: map['type'] as String? ?? '',
      model: map['model'] as String? ?? '',
      plateNumber: map['plateNumber'] as String? ?? '',
      color: map['color'] as String? ?? '',
      capacity: map['capacity'] as int? ?? 4,
    );
  }
}

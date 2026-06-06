class Vehicle {
  const Vehicle({
    required this.model,
    required this.type,
    required this.color,
    required this.capacity,
    required this.plateNumber,
  });

  final String model;
  final String type;
  final String color;
  final int capacity;
  final String plateNumber;

  Vehicle copyWith({
    String? model,
    String? type,
    String? color,
    int? capacity,
    String? plateNumber,
  }) {
    return Vehicle(
      model: model ?? this.model,
      type: type ?? this.type,
      color: color ?? this.color,
      capacity: capacity ?? this.capacity,
      plateNumber: plateNumber ?? this.plateNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'model': model,
      'type': type,
      'color': color,
      'capacity': capacity,
      'platenumber': plateNumber,
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return const Vehicle(model: '', type: '', color: '', capacity: 0, plateNumber: '');
    }
    return Vehicle(
      model: map['model'] as String? ?? '',
      type: map['type'] as String? ?? '',
      color: map['color'] as String? ?? '',
      capacity: (map['capacity'] as num?)?.toInt() ?? 0,
      plateNumber: (map['platenumber'] as String?) ?? (map['plateNumber'] as String?) ?? '',
    );
  }

  static const empty = Vehicle(model: '', type: '', color: '', capacity: 0, plateNumber: '');
}

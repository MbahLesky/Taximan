class Trip {
  const Trip({
    required this.id,
    required this.pickupLocation,
    required this.destination,
    required this.fare,
    required this.distance,
    required this.duration,
    required this.status,
    required this.date,
  });

  final String id;
  final String pickupLocation;
  final String destination;
  final int fare;
  final String distance;
  final String duration;
  final String status;
  final String date;

  String get formattedFare => '${fare.toStringAsFixed(0)} FCFA';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pickupLocation': pickupLocation,
      'destination': destination,
      'fare': fare,
      'distance': distance,
      'duration': duration,
      'status': status,
      'date': date,
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'] as String? ?? '',
      pickupLocation: map['pickupLocation'] as String? ?? '',
      destination: map['destination'] as String? ?? '',
      fare: map['fare'] as int? ?? 0,
      distance: map['distance'] as String? ?? '',
      duration: map['duration'] as String? ?? '',
      status: map['status'] as String? ?? '',
      date: map['date'] as String? ?? '',
    );
  }
}

class Trip {
  const Trip({
    required this.id,
    required this.passengerName,
    required this.pickupLocation,
    required this.destination,
    required this.fare,
    required this.distance,
    required this.eta,
    required this.status,
  });

  final String id;
  final String passengerName;
  final String pickupLocation;
  final String destination;
  final int fare;
  final String distance;
  final String eta;
  final String status;

  String get formattedFare => '${fare.toStringAsFixed(0)} FCFA';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'passengerName': passengerName,
      'pickupLocation': pickupLocation,
      'destination': destination,
      'fare': fare,
      'distance': distance,
      'eta': eta,
      'status': status,
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'] as String? ?? '',
      passengerName: map['passengerName'] as String? ?? '',
      pickupLocation: map['pickupLocation'] as String? ?? '',
      destination: map['destination'] as String? ?? '',
      fare: map['fare'] as int? ?? 0,
      distance: map['distance'] as String? ?? '',
      eta: map['eta'] as String? ?? '',
      status: map['status'] as String? ?? '',
    );
  }
}

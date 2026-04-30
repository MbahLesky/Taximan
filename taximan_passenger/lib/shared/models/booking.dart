class Booking {
  const Booking({
    required this.id,
    required this.pickupLocation,
    required this.destination,
    required this.estimatedFare,
    required this.distance,
    required this.eta,
    required this.paymentMethod,
    required this.status,
  });

  final String id;
  final String pickupLocation;
  final String destination;
  final int estimatedFare;
  final String distance;
  final String eta;
  final String paymentMethod;
  final String status;

  String get formattedFare => '${estimatedFare.toStringAsFixed(0)} FCFA';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pickupLocation': pickupLocation,
      'destination': destination,
      'estimatedFare': estimatedFare,
      'distance': distance,
      'eta': eta,
      'paymentMethod': paymentMethod,
      'status': status,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] as String? ?? '',
      pickupLocation: map['pickupLocation'] as String? ?? '',
      destination: map['destination'] as String? ?? '',
      estimatedFare: map['estimatedFare'] as int? ?? 0,
      distance: map['distance'] as String? ?? '',
      eta: map['eta'] as String? ?? '',
      paymentMethod: map['paymentMethod'] as String? ?? 'Cash',
      status: map['status'] as String? ?? 'draft',
    );
  }
}

import 'app_location.dart';
import 'model_helpers.dart';

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
    this.bookingId = '',
    this.passengerId = '',
    this.driverId = '',
    this.vehicleId = '',
    this.passengerName = 'Passenger',
    this.paymentMethod = 'cash',
    this.paymentStatus = 'pending',
    this.finalFare,
    this.startedAt,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
    this.scheduledPickupTime,
    this.pickup = const AppLocation(address: ''),
    this.destinationLocation = const AppLocation(address: ''),
  });

  final String id;
  final String bookingId;
  final String passengerId;
  final String driverId;
  final String vehicleId;
  final String passengerName;
  final String pickupLocation;
  final String destination;
  final AppLocation pickup;
  final AppLocation destinationLocation;
  final int fare;
  final String distance;
  final String duration;
  final String status;
  final String date;
  final String paymentMethod;
  final String paymentStatus;
  final int? finalFare;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? scheduledPickupTime;

  String get formattedFare => '${(finalFare ?? fare).toStringAsFixed(0)} FCFA';
  String get formattedFinalFare => '${(finalFare ?? fare).toStringAsFixed(0)} FCFA';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookingId': bookingId,
      'passengerId': passengerId,
      'driverId': driverId,
      'vehicleId': vehicleId,
      'passengerName': passengerName,
      'pickupLocation': pickup.toMap(),
      'pickupLocationText': pickup.address,
      'destinationLocation': destinationLocation.toMap(),
      'destination': destinationLocation.address,
      'fare': fare,
      'finalFare': finalFare,
      'distance': distance,
      'duration': duration,
      'status': status,
      'date': date,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'scheduledPickupTime': writeDateTime(scheduledPickupTime),
      'startedAt': writeDateTime(startedAt),
      'completedAt': writeDateTime(completedAt),
      'createdAt': writeDateTime(createdAt),
      'updatedAt': writeDateTime(updatedAt),
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    final pickup = AppLocation.fromValue(map['pickupLocation'] ?? map['pickupLocationText']);
    final destination = AppLocation.fromValue(map['destinationLocation'] ?? map['destination']);
    final durationMinutes = (map['estimatedDurationMinutes'] as num?)?.toInt();
    final createdAt = readDateTime(map['createdAt']);
    final scheduledPickupTime = readDateTime(map['scheduledPickupTime']);
    final startedAt = readDateTime(map['startedAt']);
    final completedAt = readDateTime(map['completedAt']);
    final updatedAt = readDateTime(map['updatedAt']);

    return Trip(
      id: map['id'] as String? ?? '',
      bookingId: map['bookingId'] as String? ?? '',
      passengerId: map['passengerId'] as String? ?? '',
      driverId: map['driverId'] as String? ?? '',
      vehicleId: map['vehicleId'] as String? ?? '',
      passengerName: map['passengerName'] as String? ?? 'Passenger',
      pickupLocation: pickup.address,
      destination: destination.address,
      pickup: pickup,
      destinationLocation: destination,
      fare: (map['fare'] as num?)?.toInt() ?? (map['estimatedFare'] as num?)?.toInt() ?? 0,
      distance: map['distance'] as String? ?? (map['distanceKm'] is num ? '${(map['distanceKm'] as num).toDouble().toStringAsFixed(1)} km' : ''),
      duration: map['duration'] as String? ?? (durationMinutes == null ? '' : '$durationMinutes min'),
      status: map['status'] as String? ?? '',
      date: map['date'] as String? ?? _formatDisplayDate(scheduledPickupTime ?? completedAt ?? createdAt ?? startedAt),
      paymentMethod: map['paymentMethod'] as String? ?? 'cash',
      paymentStatus: map['paymentStatus'] as String? ?? 'pending',
      finalFare: (map['finalFare'] as num?)?.toInt(),
      startedAt: startedAt,
      completedAt: completedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      scheduledPickupTime: scheduledPickupTime,
    );
  }
}

String _formatDisplayDate(DateTime? value) {
  if (value == null) return '';
  return '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
}

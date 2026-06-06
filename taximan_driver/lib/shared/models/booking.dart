import 'app_location.dart';
import 'model_helpers.dart';

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
    this.passengerId = '',
    this.passengerName = 'Passenger',
    this.driverId,
    this.preferredDriverId,
    this.vehicleId,
    this.passengerCount = 1,
    this.hasLuggage = false,
    this.luggageCount = 0,
    this.isRideSharing = false,
    this.additionalInfo = '',
    this.finalFare,
    this.pickup = const AppLocation(address: ''),
    this.destinationLocation = const AppLocation(address: ''),
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String pickupLocation;
  final String destination;
  final int estimatedFare;
  final String distance;
  final String eta;
  final String paymentMethod;
  final String status;
  final String passengerId;
  final String passengerName;
  final String? driverId;
  final String? preferredDriverId;
  final String? vehicleId;
  final int passengerCount;
  final bool hasLuggage;
  final int luggageCount;
  final bool isRideSharing;
  final String additionalInfo;
  final int? finalFare;
  final AppLocation pickup;
  final AppLocation destinationLocation;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get formattedFare => '${(finalFare ?? estimatedFare)} FCFA';

  factory Booking.fromMap(Map<String, dynamic> map) {
    final pickup = AppLocation.fromValue(
      map['pickupLocation'] ?? map['pickupLocationText'],
    );
    final destination = AppLocation.fromValue(
      map['destinationLocation'] ?? map['destination'],
    );
    final distanceKm = (map['distanceKm'] as num?)?.toDouble();
    final durationMinutes = (map['estimatedDurationMinutes'] as num?)?.toInt();

    return Booking(
      id: map['id'] as String? ?? '',
      pickupLocation: pickup.address,
      destination: destination.address,
      estimatedFare: (map['estimatedFare'] as num?)?.toInt() ?? 0,
      distance:
          map['distance'] as String? ??
          (distanceKm == null ? '' : '${distanceKm.toStringAsFixed(1)} km'),
      eta:
          map['eta'] as String? ??
          (durationMinutes == null ? '' : '$durationMinutes min'),
      paymentMethod: map['paymentMethod'] as String? ?? 'Cash',
      status: map['status'] as String? ?? 'draft',
      passengerId: map['passengerId'] as String? ?? '',
      passengerName:
          (map['passengerName'] as String?) ??
          (map['preferredPassengerName'] as String?) ??
          'Passenger',
      driverId: map['driverId'] as String?,
      preferredDriverId: map['preferredDriverId'] as String?,
      vehicleId: map['vehicleId'] as String?,
      passengerCount: (map['passengerCount'] as num?)?.toInt() ?? 1,
      hasLuggage: map['hasLuggage'] as bool? ?? false,
      luggageCount: (map['luggageCount'] as num?)?.toInt() ?? 0,
      isRideSharing: map['isRideSharing'] as bool? ?? false,
      additionalInfo: map['additionalInfo'] as String? ?? '',
      finalFare: (map['finalFare'] as num?)?.toInt(),
      pickup: pickup,
      destinationLocation: destination,
      createdAt: readDateTime(map['createdAt']),
      updatedAt: readDateTime(map['updatedAt']),
    );
  }
}

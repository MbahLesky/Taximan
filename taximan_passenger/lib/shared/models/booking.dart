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
    this.driverId,
    this.vehicleId,
    this.pickupTimeType = 'now',
    this.scheduledPickupTime,
    this.isRideSharing = false,
    this.finalFare,
    this.paymentStatus = 'pending',
    this.createdAt,
    this.updatedAt,
    this.acceptedAt,
    this.cancelledAt,
    this.cancellationReason,
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
  final String? driverId;
  final String? vehicleId;
  final String pickupTimeType;
  final DateTime? scheduledPickupTime;
  final bool isRideSharing;
  final int? finalFare;
  final String paymentStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? acceptedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;

  String get formattedFare => '${estimatedFare.toStringAsFixed(0)} FCFA';
  String get formattedFinalFare => '${(finalFare ?? estimatedFare)} FCFA';
  AppLocation get pickup => AppLocation(address: pickupLocation);
  AppLocation get destinationLocation => AppLocation(address: destination);

  Booking copyWith({
    String? id,
    String? pickupLocation,
    String? destination,
    int? estimatedFare,
    String? distance,
    String? eta,
    String? paymentMethod,
    String? status,
    String? passengerId,
    String? driverId,
    String? vehicleId,
    String? pickupTimeType,
    DateTime? scheduledPickupTime,
    bool? isRideSharing,
    int? finalFare,
    String? paymentStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? acceptedAt,
    DateTime? cancelledAt,
    String? cancellationReason,
  }) {
    return Booking(
      id: id ?? this.id,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      destination: destination ?? this.destination,
      estimatedFare: estimatedFare ?? this.estimatedFare,
      distance: distance ?? this.distance,
      eta: eta ?? this.eta,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      passengerId: passengerId ?? this.passengerId,
      driverId: driverId ?? this.driverId,
      vehicleId: vehicleId ?? this.vehicleId,
      pickupTimeType: pickupTimeType ?? this.pickupTimeType,
      scheduledPickupTime: scheduledPickupTime ?? this.scheduledPickupTime,
      isRideSharing: isRideSharing ?? this.isRideSharing,
      finalFare: finalFare ?? this.finalFare,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'passengerId': passengerId,
      'driverId': driverId,
      'vehicleId': vehicleId,
      'pickupLocation': pickup.toMap(),
      'pickupLocationText': pickupLocation,
      'destinationLocation': destinationLocation.toMap(),
      'destination': destination,
      'pickupTimeType': pickupTimeType,
      'scheduledPickupTime': writeDateTime(scheduledPickupTime),
      'isRideSharing': isRideSharing,
      'estimatedFare': estimatedFare,
      'finalFare': finalFare,
      'distance': distance,
      'eta': eta,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'status': status,
      'createdAt': writeDateTime(createdAt),
      'updatedAt': writeDateTime(updatedAt),
      'acceptedAt': writeDateTime(acceptedAt),
      'cancelledAt': writeDateTime(cancelledAt),
      'cancellationReason': cancellationReason,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    final pickup = AppLocation.fromValue(
      map['pickupLocation'] ?? map['pickupLocationText'],
    );
    final destinationLocation = AppLocation.fromValue(
      map['destinationLocation'] ?? map['destination'],
    );
    final distanceKm = (map['distanceKm'] as num?)?.toDouble();
    final durationMinutes = map['estimatedDurationMinutes'] as int?;

    return Booking(
      id: map['id'] as String? ?? '',
      pickupLocation: pickup.address,
      destination: destinationLocation.address,
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
      driverId: map['driverId'] as String?,
      vehicleId: map['vehicleId'] as String?,
      pickupTimeType: map['pickupTimeType'] as String? ?? 'now',
      scheduledPickupTime: readDateTime(map['scheduledPickupTime']),
      isRideSharing: map['isRideSharing'] as bool? ?? false,
      finalFare: (map['finalFare'] as num?)?.toInt(),
      paymentStatus: map['paymentStatus'] as String? ?? 'pending',
      createdAt: readDateTime(map['createdAt']),
      updatedAt: readDateTime(map['updatedAt']),
      acceptedAt: readDateTime(map['acceptedAt']),
      cancelledAt: readDateTime(map['cancelledAt']),
      cancellationReason: map['cancellationReason'] as String?,
    );
  }
}

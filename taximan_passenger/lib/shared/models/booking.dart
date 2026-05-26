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
    this.distanceKm,
    this.estimatedDurationMinutes,
    this.passengerId = '',
    this.driverId,
    this.preferredDriverId,
    this.preferredDriverName,
    this.vehicleId,
    this.pickupTimeType = 'now',
    this.scheduledPickupTime,
    this.isRideSharing = false,
    this.passengerCount = 1,
    this.hasLuggage = false,
    this.luggageCount = 0,
    this.proposedFareAmount = 0,
    this.additionalInfo = '',
    this.pickupLocationDetails,
    this.destinationLocationDetails,
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
  final double? distanceKm;
  final int? estimatedDurationMinutes;
  final String passengerId;
  final String? driverId;
  final String? preferredDriverId;
  final String? preferredDriverName;
  final String? vehicleId;
  final String pickupTimeType;
  final DateTime? scheduledPickupTime;
  final bool isRideSharing;
  final int passengerCount;
  final bool hasLuggage;
  final int luggageCount;
  final int proposedFareAmount;
  final String additionalInfo;
  final AppLocation? pickupLocationDetails;
  final AppLocation? destinationLocationDetails;
  final int? finalFare;
  final String paymentStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? acceptedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;

  String get formattedFare => '${estimatedFare.toStringAsFixed(0)} FCFA';
  String get formattedFinalFare => '${(finalFare ?? estimatedFare)} FCFA';
  String get formattedProposedFare => '$proposedFareAmount FCFA';
  AppLocation get pickup =>
      pickupLocationDetails ?? AppLocation(address: pickupLocation);
  AppLocation get destinationLocation =>
      destinationLocationDetails ?? AppLocation(address: destination);

  Booking copyWith({
    String? id,
    String? pickupLocation,
    String? destination,
    int? estimatedFare,
    String? distance,
    String? eta,
    String? paymentMethod,
    String? status,
    double? distanceKm,
    int? estimatedDurationMinutes,
    String? passengerId,
    String? driverId,
    String? preferredDriverId,
    String? preferredDriverName,
    String? vehicleId,
    String? pickupTimeType,
    DateTime? scheduledPickupTime,
    bool? isRideSharing,
    int? passengerCount,
    bool? hasLuggage,
    int? luggageCount,
    int? proposedFareAmount,
    String? additionalInfo,
    AppLocation? pickupLocationDetails,
    AppLocation? destinationLocationDetails,
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
      distanceKm: distanceKm ?? this.distanceKm,
      estimatedDurationMinutes:
          estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      passengerId: passengerId ?? this.passengerId,
      driverId: driverId ?? this.driverId,
      preferredDriverId: preferredDriverId ?? this.preferredDriverId,
      preferredDriverName: preferredDriverName ?? this.preferredDriverName,
      vehicleId: vehicleId ?? this.vehicleId,
      pickupTimeType: pickupTimeType ?? this.pickupTimeType,
      scheduledPickupTime: scheduledPickupTime ?? this.scheduledPickupTime,
      isRideSharing: isRideSharing ?? this.isRideSharing,
      passengerCount: passengerCount ?? this.passengerCount,
      hasLuggage: hasLuggage ?? this.hasLuggage,
      luggageCount: luggageCount ?? this.luggageCount,
      proposedFareAmount: proposedFareAmount ?? this.proposedFareAmount,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      pickupLocationDetails:
          pickupLocationDetails ?? this.pickupLocationDetails,
      destinationLocationDetails:
          destinationLocationDetails ?? this.destinationLocationDetails,
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
      'preferredDriverId': preferredDriverId?.isEmpty == true
          ? null
          : preferredDriverId,
      'preferredDriverName': preferredDriverName?.isEmpty == true
          ? null
          : preferredDriverName,
      'vehicleId': vehicleId,
      'pickupLocation': pickup.toMap(),
      'pickupLocationText': pickupLocation,
      'destinationLocation': destinationLocation.toMap(),
      'destination': destination,
      'pickupTimeType': pickupTimeType,
      'scheduledPickupTime': writeDateTime(scheduledPickupTime),
      'isRideSharing': isRideSharing,
      'passengerCount': passengerCount,
      'hasLuggage': hasLuggage,
      'luggageCount': luggageCount,
      'proposedFareAmount': proposedFareAmount,
      'additionalInfo': additionalInfo,
      'estimatedFare': estimatedFare,
      'finalFare': finalFare,
      'distance': distance,
      'eta': eta,
      'distanceKm': distanceKm,
      'estimatedDurationMinutes': estimatedDurationMinutes,
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
    final durationMinutes = (map['estimatedDurationMinutes'] as num?)?.toInt();

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
      distanceKm: distanceKm,
      estimatedDurationMinutes: durationMinutes,
      passengerId: map['passengerId'] as String? ?? '',
      driverId: map['driverId'] as String?,
      preferredDriverId: map['preferredDriverId'] as String?,
      preferredDriverName: map['preferredDriverName'] as String?,
      vehicleId: map['vehicleId'] as String?,
      pickupTimeType: map['pickupTimeType'] as String? ?? 'now',
      scheduledPickupTime: readDateTime(map['scheduledPickupTime']),
      isRideSharing: map['isRideSharing'] as bool? ?? false,
      passengerCount: (map['passengerCount'] as num?)?.toInt() ?? 1,
      hasLuggage: map['hasLuggage'] as bool? ?? false,
      luggageCount: (map['luggageCount'] as num?)?.toInt() ?? 0,
      proposedFareAmount:
          (map['proposedFareAmount'] as num?)?.toInt() ??
          (map['proposedFare'] as num?)?.toInt() ??
          0,
      additionalInfo: map['additionalInfo'] as String? ?? '',
      pickupLocationDetails: pickup,
      destinationLocationDetails: destinationLocation,
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

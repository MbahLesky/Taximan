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
    this.scheduledPickupTime,
    this.actualDurationMinutes,
    this.finalFare,
    this.paymentMethod = 'cash',
    this.paymentStatus = 'pending',
    this.pickupLocationDetails,
    this.destinationLocationDetails,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String pickupLocation;
  final String destination;
  final int fare;
  final String distance;
  final String duration;
  final String status;
  final String date;
  final String bookingId;
  final String passengerId;
  final String driverId;
  final String vehicleId;
  final DateTime? scheduledPickupTime;
  final int? actualDurationMinutes;
  final int? finalFare;
  final String paymentMethod;
  final String paymentStatus;
  final AppLocation? pickupLocationDetails;
  final AppLocation? destinationLocationDetails;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get formattedFare => '${fare.toStringAsFixed(0)} FCFA';
  String get formattedFinalFare => '${(finalFare ?? fare)} FCFA';
  AppLocation get pickup =>
      pickupLocationDetails ?? AppLocation(address: pickupLocation);
  AppLocation get destinationLocation =>
      destinationLocationDetails ?? AppLocation(address: destination);

  Trip copyWith({
    String? id,
    String? pickupLocation,
    String? destination,
    int? fare,
    String? distance,
    String? duration,
    String? status,
    String? date,
    String? bookingId,
    String? passengerId,
    String? driverId,
    String? vehicleId,
    DateTime? scheduledPickupTime,
    int? actualDurationMinutes,
    int? finalFare,
    String? paymentMethod,
    String? paymentStatus,
    AppLocation? pickupLocationDetails,
    AppLocation? destinationLocationDetails,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Trip(
      id: id ?? this.id,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      destination: destination ?? this.destination,
      fare: fare ?? this.fare,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      date: date ?? this.date,
      bookingId: bookingId ?? this.bookingId,
      passengerId: passengerId ?? this.passengerId,
      driverId: driverId ?? this.driverId,
      vehicleId: vehicleId ?? this.vehicleId,
      scheduledPickupTime: scheduledPickupTime ?? this.scheduledPickupTime,
      actualDurationMinutes:
          actualDurationMinutes ?? this.actualDurationMinutes,
      finalFare: finalFare ?? this.finalFare,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      pickupLocationDetails:
          pickupLocationDetails ?? this.pickupLocationDetails,
      destinationLocationDetails:
          destinationLocationDetails ?? this.destinationLocationDetails,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookingId': bookingId,
      'passengerId': passengerId,
      'driverId': driverId,
      'vehicleId': vehicleId,
      'pickupLocation': pickup.toMap(),
      'pickupLocationText': pickupLocation,
      'destinationLocation': destinationLocation.toMap(),
      'destination': destination,
      'scheduledPickupTime': writeDateTime(scheduledPickupTime),
      'fare': fare,
      'estimatedFare': fare,
      'finalFare': finalFare,
      'distance': distance,
      'duration': duration,
      'actualDurationMinutes': actualDurationMinutes,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'status': status,
      'date': date,
      'startedAt': writeDateTime(startedAt),
      'completedAt': writeDateTime(completedAt),
      'cancelledAt': writeDateTime(cancelledAt),
      'createdAt': writeDateTime(createdAt),
      'updatedAt': writeDateTime(updatedAt),
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    final pickup = AppLocation.fromValue(
      map['pickupLocation'] ?? map['pickupLocationText'],
    );
    final destinationLocation = AppLocation.fromValue(
      map['destinationLocation'] ?? map['destination'],
    );
    final distanceKm = (map['distanceKm'] as num?)?.toDouble();
    final durationMinutes = (map['estimatedDurationMinutes'] as num?)?.toInt();
    final startedAt = readDateTime(map['startedAt']);
    final completedAt = readDateTime(map['completedAt']);
    final cancelledAt = readDateTime(map['cancelledAt']);
    final createdAt = readDateTime(map['createdAt']);
    final updatedAt = readDateTime(map['updatedAt']);
    final scheduledPickupTime = readDateTime(map['scheduledPickupTime']);

    return Trip(
      id: map['id'] as String? ?? '',
      pickupLocation: pickup.address,
      destination: destinationLocation.address,
      fare:
          (map['fare'] as num?)?.toInt() ??
          (map['estimatedFare'] as num?)?.toInt() ??
          0,
      distance:
          map['distance'] as String? ??
          (distanceKm == null ? '' : '${distanceKm.toStringAsFixed(1)} km'),
      duration:
          map['duration'] as String? ??
          (durationMinutes == null ? '' : '$durationMinutes min'),
      status: map['status'] as String? ?? '',
      date:
          map['date'] as String? ??
          _formatDisplayDate(
            scheduledPickupTime ?? completedAt ?? createdAt ?? startedAt,
          ),
      bookingId: map['bookingId'] as String? ?? '',
      passengerId: map['passengerId'] as String? ?? '',
      driverId: map['driverId'] as String? ?? '',
      vehicleId: map['vehicleId'] as String? ?? '',
      scheduledPickupTime: scheduledPickupTime,
      actualDurationMinutes: (map['actualDurationMinutes'] as num?)?.toInt(),
      finalFare: (map['finalFare'] as num?)?.toInt(),
      paymentMethod: map['paymentMethod'] as String? ?? 'cash',
      paymentStatus: map['paymentStatus'] as String? ?? 'pending',
      pickupLocationDetails: pickup,
      destinationLocationDetails: destinationLocation,
      startedAt: startedAt,
      completedAt: completedAt,
      cancelledAt: cancelledAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

String _formatDisplayDate(DateTime? value) {
  if (value == null) {
    return '';
  }
  return '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}/'
      '${value.year}';
}

import 'model_helpers.dart';

class FareProposal {
  const FareProposal({
    required this.id,
    required this.bookingId,
    required this.driverId,
    required this.vehicleId,
    required this.originalFare,
    required this.proposedFare,
    this.message = '',
    this.status = 'pending',
    this.createdAt,
    this.respondedAt,
  });

  final String id;
  final String bookingId;
  final String driverId;
  final String vehicleId;
  final int originalFare;
  final int proposedFare;
  final String message;
  final String status;
  final DateTime? createdAt;
  final DateTime? respondedAt;

  String get formattedOriginalFare => '$originalFare FCFA';
  String get formattedProposedFare => '$proposedFare FCFA';

  FareProposal copyWith({
    String? id,
    String? bookingId,
    String? driverId,
    String? vehicleId,
    int? originalFare,
    int? proposedFare,
    String? message,
    String? status,
    DateTime? createdAt,
    DateTime? respondedAt,
  }) {
    return FareProposal(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      driverId: driverId ?? this.driverId,
      vehicleId: vehicleId ?? this.vehicleId,
      originalFare: originalFare ?? this.originalFare,
      proposedFare: proposedFare ?? this.proposedFare,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookingId': bookingId,
      'driverId': driverId,
      'vehicleId': vehicleId,
      'originalFare': originalFare,
      'proposedFare': proposedFare,
      'message': message,
      'status': status,
      'createdAt': writeDateTime(createdAt),
      'respondedAt': writeDateTime(respondedAt),
    };
  }

  factory FareProposal.fromMap(Map<String, dynamic> map) {
    return FareProposal(
      id: map['id'] as String? ?? '',
      bookingId: map['bookingId'] as String? ?? '',
      driverId: map['driverId'] as String? ?? '',
      vehicleId: map['vehicleId'] as String? ?? '',
      originalFare: (map['originalFare'] as num?)?.toInt() ?? 0,
      proposedFare: (map['proposedFare'] as num?)?.toInt() ?? 0,
      message: map['message'] as String? ?? '',
      status: map['status'] as String? ?? 'pending',
      createdAt: readDateTime(map['createdAt']),
      respondedAt: readDateTime(map['respondedAt']),
    );
  }
}

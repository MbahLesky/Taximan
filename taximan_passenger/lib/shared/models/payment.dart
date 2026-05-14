import 'model_helpers.dart';

class Payment {
  const Payment({
    required this.id,
    required this.bookingId,
    required this.tripId,
    required this.passengerId,
    required this.driverId,
    required this.amount,
    this.method = 'cash',
    this.status = 'pending',
    this.confirmedBy,
    this.createdAt,
    this.confirmedAt,
  });

  final String id;
  final String bookingId;
  final String tripId;
  final String passengerId;
  final String driverId;
  final int amount;
  final String method;
  final String status;
  final String? confirmedBy;
  final DateTime? createdAt;
  final DateTime? confirmedAt;

  String get formattedAmount => '$amount FCFA';
  bool get isPaid => status == 'paid';

  Payment copyWith({
    String? id,
    String? bookingId,
    String? tripId,
    String? passengerId,
    String? driverId,
    int? amount,
    String? method,
    String? status,
    String? confirmedBy,
    DateTime? createdAt,
    DateTime? confirmedAt,
  }) {
    return Payment(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      tripId: tripId ?? this.tripId,
      passengerId: passengerId ?? this.passengerId,
      driverId: driverId ?? this.driverId,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      status: status ?? this.status,
      confirmedBy: confirmedBy ?? this.confirmedBy,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookingId': bookingId,
      'tripId': tripId,
      'passengerId': passengerId,
      'driverId': driverId,
      'amount': amount,
      'method': method,
      'status': status,
      'confirmedBy': confirmedBy,
      'createdAt': writeDateTime(createdAt),
      'confirmedAt': writeDateTime(confirmedAt),
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'] as String? ?? '',
      bookingId: map['bookingId'] as String? ?? '',
      tripId: map['tripId'] as String? ?? '',
      passengerId: map['passengerId'] as String? ?? '',
      driverId: map['driverId'] as String? ?? '',
      amount: (map['amount'] as num?)?.toInt() ?? 0,
      method: map['method'] as String? ?? 'cash',
      status: map['status'] as String? ?? 'pending',
      confirmedBy: map['confirmedBy'] as String?,
      createdAt: readDateTime(map['createdAt']),
      confirmedAt: readDateTime(map['confirmedAt']),
    );
  }
}

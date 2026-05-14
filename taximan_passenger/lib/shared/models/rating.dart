import 'model_helpers.dart';

class Rating {
  const Rating({
    required this.id,
    required this.tripId,
    required this.bookingId,
    required this.passengerId,
    required this.driverId,
    required this.rating,
    this.comment = '',
    this.reportIssue = false,
    this.issueType,
    this.createdAt,
  });

  final String id;
  final String tripId;
  final String bookingId;
  final String passengerId;
  final String driverId;
  final int rating;
  final String comment;
  final bool reportIssue;
  final String? issueType;
  final DateTime? createdAt;

  Rating copyWith({
    String? id,
    String? tripId,
    String? bookingId,
    String? passengerId,
    String? driverId,
    int? rating,
    String? comment,
    bool? reportIssue,
    String? issueType,
    DateTime? createdAt,
  }) {
    return Rating(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      bookingId: bookingId ?? this.bookingId,
      passengerId: passengerId ?? this.passengerId,
      driverId: driverId ?? this.driverId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      reportIssue: reportIssue ?? this.reportIssue,
      issueType: issueType ?? this.issueType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tripId': tripId,
      'bookingId': bookingId,
      'passengerId': passengerId,
      'driverId': driverId,
      'rating': rating,
      'comment': comment,
      'reportIssue': reportIssue,
      'issueType': issueType,
      'createdAt': writeDateTime(createdAt),
    };
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      id: map['id'] as String? ?? '',
      tripId: map['tripId'] as String? ?? '',
      bookingId: map['bookingId'] as String? ?? '',
      passengerId: map['passengerId'] as String? ?? '',
      driverId: map['driverId'] as String? ?? '',
      rating: (map['rating'] as num?)?.toInt() ?? 0,
      comment: map['comment'] as String? ?? '',
      reportIssue: map['reportIssue'] as bool? ?? false,
      issueType: map['issueType'] as String?,
      createdAt: readDateTime(map['createdAt']),
    );
  }
}

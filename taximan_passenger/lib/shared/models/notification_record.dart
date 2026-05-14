import 'model_helpers.dart';

class NotificationRecord {
  const NotificationRecord({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.userRole = 'passenger',
    this.isRead = false,
    this.relatedId,
    this.createdAt,
  });

  final String id;
  final String userId;
  final String userRole;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final String? relatedId;
  final DateTime? createdAt;

  NotificationRecord copyWith({
    String? id,
    String? userId,
    String? userRole,
    String? title,
    String? body,
    String? type,
    bool? isRead,
    String? relatedId,
    DateTime? createdAt,
  }) {
    return NotificationRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userRole: userRole ?? this.userRole,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      relatedId: relatedId ?? this.relatedId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userRole': userRole,
      'title': title,
      'body': body,
      'type': type,
      'isRead': isRead,
      'relatedId': relatedId,
      'createdAt': writeDateTime(createdAt),
    };
  }

  factory NotificationRecord.fromMap(Map<String, dynamic> map) {
    return NotificationRecord(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      userRole: map['userRole'] as String? ?? 'passenger',
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      type: map['type'] as String? ?? '',
      isRead: map['isRead'] as bool? ?? false,
      relatedId: map['relatedId'] as String?,
      createdAt: readDateTime(map['createdAt']),
    );
  }
}

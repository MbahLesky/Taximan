import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/models/notification_record.dart';

class NotificationRepository {
  NotificationRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _collection = 'notifications';

  Stream<List<NotificationRecord>> streamUserNotifications(String userId) {
    final trimmedUserId = userId.trim();
    if (trimmedUserId.isEmpty) {
      return Stream<List<NotificationRecord>>.value(const []);
    }

    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: trimmedUserId)
        .snapshots()
        .map((snapshot) {
          final notifications = snapshot.docs
              .map(
                (doc) =>
                    NotificationRecord.fromMap({...doc.data(), 'id': doc.id}),
              )
              .toList();

          notifications.sort((a, b) {
            final aCreated =
                a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bCreated =
                b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final createdComparison = bCreated.compareTo(aCreated);
            if (createdComparison != 0) {
              return createdComparison;
            }
            return b.id.compareTo(a.id);
          });

          return notifications.take(50).toList();
        });
  }

  Future<void> addNotification(NotificationRecord notification) async {
    final docRef = notification.id.isEmpty
        ? _firestore.collection(_collection).doc()
        : _firestore.collection(_collection).doc(notification.id);
    final data = notification.copyWith(id: docRef.id).toMap();
    data['createdAt'] = notification.createdAt == null
        ? FieldValue.serverTimestamp()
        : Timestamp.fromDate(notification.createdAt!);

    await docRef.set(data);
  }

  Future<void> markAsRead(String notificationId) async {
    if (notificationId.trim().isEmpty) {
      return;
    }

    await _firestore.collection(_collection).doc(notificationId).update({
      'isRead': true,
    });
  }

  Future<void> markAllAsRead(String userId) async {
    final query = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    if (query.docs.isEmpty) {
      return;
    }

    final batch = _firestore.batch();
    for (final doc in query.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/notification_record.dart';

class NotificationState {
  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<NotificationRecord> notifications;
  final bool isLoading;
  final String? errorMessage;

  int get unreadCount =>
      notifications.where((notification) => !notification.isRead).length;

  NotificationState copyWith({
    List<NotificationRecord>? notifications,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class NotificationController extends StateNotifier<NotificationState> {
  NotificationController()
    : super(
        NotificationState(
          notifications: [
            NotificationRecord(
              id: 'notification-demo-001',
              userId: 'passenger-001',
              title: 'Driver Assigned',
              body: 'Jean Talla is on the way to your pickup point.',
              type: 'driver_assigned',
              relatedId: 'booking-demo-001',
              createdAt: DateTime.now(),
            ),
          ],
        ),
      );

  void addNotification(NotificationRecord notification) {
    state = state.copyWith(
      notifications: [notification, ...state.notifications],
      errorMessage: null,
    );
  }

  void markAsRead(String notificationId) {
    state = state.copyWith(
      notifications: [
        for (final notification in state.notifications)
          if (notification.id == notificationId)
            notification.copyWith(isRead: true)
          else
            notification,
      ],
    );
  }

  void markAllAsRead() {
    state = state.copyWith(
      notifications: [
        for (final notification in state.notifications)
          notification.copyWith(isRead: true),
      ],
    );
  }
}

final notificationStateProvider =
    StateNotifierProvider<NotificationController, NotificationState>(
      (ref) => NotificationController(),
    );

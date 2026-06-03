import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/notification_record.dart';
import '../../../auth/application/providers/auth_state_provider.dart';
import '../../data/notification_repository.dart';

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
  NotificationController({
    required NotificationRepository repository,
    required String? userId,
  }) : _repository = repository,
       _userId = userId?.trim(),
       super(const NotificationState()) {
    _startListening();
  }

  final NotificationRepository _repository;
  final String? _userId;
  StreamSubscription<List<NotificationRecord>>? _subscription;

  void _startListening() {
    final userId = _userId;
    if (userId == null || userId.isEmpty) {
      state = const NotificationState();
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    _subscription = _repository
        .streamUserNotifications(userId)
        .listen(
          (notifications) {
            state = state.copyWith(
              notifications: notifications,
              isLoading: false,
              errorMessage: null,
            );
          },
          onError: (Object error) {
            state = state.copyWith(
              isLoading: false,
              errorMessage: 'Unable to load notifications. Please try again.',
            );
          },
        );
  }

  Future<void> addNotification(NotificationRecord notification) async {
    final targetUserId = notification.userId.trim().isNotEmpty
        ? notification.userId
        : _userId;
    if (targetUserId == null || targetUserId.isEmpty) {
      state = state.copyWith(errorMessage: 'Sign in to save notifications.');
      return;
    }

    final notificationToSave = notification.copyWith(
      userId: targetUserId,
      createdAt: notification.createdAt ?? DateTime.now(),
    );

    state = state.copyWith(
      notifications: [notificationToSave, ...state.notifications],
      errorMessage: null,
    );

    try {
      await _repository.addNotification(notificationToSave);
    } catch (_) {
      state = state.copyWith(
        errorMessage: 'Unable to save notification. Please try again.',
      );
    }
  }

  Future<void> markAsRead(String notificationId) async {
    if (notificationId.isEmpty ||
        !state.notifications.any(
          (notification) =>
              notification.id == notificationId && !notification.isRead,
        )) {
      return;
    }

    state = state.copyWith(
      notifications: [
        for (final notification in state.notifications)
          if (notification.id == notificationId)
            notification.copyWith(isRead: true)
          else
            notification,
      ],
      errorMessage: null,
    );

    try {
      await _repository.markAsRead(notificationId);
    } catch (_) {
      state = state.copyWith(
        errorMessage: 'Unable to update notification. Please try again.',
      );
    }
  }

  Future<void> markAllAsRead() async {
    final userId = _userId;
    if (state.notifications.every((notification) => notification.isRead)) {
      return;
    }

    state = state.copyWith(
      notifications: [
        for (final notification in state.notifications)
          notification.copyWith(isRead: true),
      ],
      errorMessage: null,
    );

    if (userId == null || userId.isEmpty) {
      return;
    }

    try {
      await _repository.markAllAsRead(userId);
    } catch (_) {
      state = state.copyWith(
        errorMessage: 'Unable to update notifications. Please try again.',
      );
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

final notificationStateProvider =
    StateNotifierProvider<NotificationController, NotificationState>((ref) {
      final userId = ref.watch(
        authStateProvider.select((state) => state.userId),
      );
      return NotificationController(
        repository: ref.watch(notificationRepositoryProvider),
        userId: userId,
      );
    });

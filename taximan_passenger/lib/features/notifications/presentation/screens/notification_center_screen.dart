import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../auth/application/providers/auth_state_provider.dart';
import '../../../notifications/application/providers/notification_state_provider.dart';
import '../../../../shared/models/notification_record.dart';

class NotificationCenterScreen extends ConsumerWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationStateProvider);
    final notifications = notificationState.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: notifications.isEmpty
                ? null
                : () {
                    ref
                        .read(notificationStateProvider.notifier)
                        .markAllAsRead();
                  },
            child: Text(
              'Mark all read',
              style: TextStyle(
                color: notifications.isEmpty
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: notifications.isEmpty
            ? Center(
                child: Text(
                  'No notifications yet.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            : ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Material(
                    color: notification.isRead
                        ? Theme.of(context).colorScheme.surface
                        : AppColors.primaryLight.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(16),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      title: Text(
                        notification.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(notification.body),
                      trailing: notification.isRead
                          ? null
                          : const Icon(
                              Icons.circle,
                              color: AppColors.primaryDark,
                              size: 10,
                            ),
                      onTap: () {
                        ref
                            .read(notificationStateProvider.notifier)
                            .markAsRead(notification.id);
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final authState = ref.read(authStateProvider);
          final userId = authState.userId ?? 'unknown-user';
          final id = DateTime.now().millisecondsSinceEpoch.toString();

          ref.read(notificationStateProvider.notifier).addNotification(
                NotificationRecord(
                  id: id,
                  userId: userId,
                  title: 'Ride update',
                  body: 'Your driver is arriving shortly. Please be ready.',
                  type: 'ride_update',
                  createdAt: DateTime.now(),
                ),
              );
        },
        icon: const Icon(Icons.notification_add),
        label: const Text('Add sample'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../notifications/application/providers/notification_state_provider.dart';
import '../../../../shared/models/notification_record.dart';

class NotificationCenterScreen extends ConsumerWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationStateProvider);
    final notifications = notificationState.notifications;
    final hasUnread = notificationState.unreadCount > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: hasUnread
                ? () {
                    ref
                        .read(notificationStateProvider.notifier)
                        .markAllAsRead();
                  }
                : null,
            child: Text(
              'Mark all read',
              style: TextStyle(
                color: !hasUnread
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: notificationState.isLoading && notifications.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : notifications.isEmpty
            ? Center(
                child: Text(
                  notificationState.errorMessage ?? 'No notifications yet.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.separated(
                itemCount:
                    notifications.length +
                    (notificationState.errorMessage == null ? 0 : 1),
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  if (notificationState.errorMessage != null && index == 0) {
                    return _NotificationErrorBanner(
                      message: notificationState.errorMessage!,
                    );
                  }

                  final notificationIndex =
                      index - (notificationState.errorMessage == null ? 0 : 1);
                  final notification = notifications[notificationIndex];
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
                        style: Theme.of(context).textTheme.titleMedium
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
                      onTap: () async {
                        await ref
                            .read(notificationStateProvider.notifier)
                            .markAsRead(notification.id);
                        if (context.mounted) {
                          _openRelatedRoute(context, notification);
                        }
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _openRelatedRoute(
    BuildContext context,
    NotificationRecord notification,
  ) {
    final relatedId = notification.relatedId?.trim();
    if (relatedId == null || relatedId.isEmpty) {
      return;
    }

    switch (notification.type) {
      case 'fare_proposal':
      case 'fare_proposals':
      case 'new_booking':
      case 'proposal_response':
      case 'ride_cancelled':
        context.push('/booking/$relatedId');
        break;
      case 'driver_assigned':
      case 'driver_arriving':
      case 'driver_arrived':
      case 'ride_approved':
      case 'trip_started':
      case 'trip_completed':
      case 'payment_confirmed':
        context.push('/trip/$relatedId');
        break;
    }
  }
}

class _NotificationErrorBanner extends StatelessWidget {
  const _NotificationErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colorScheme.onErrorContainer),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

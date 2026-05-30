import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../application/providers/booking_provider.dart';
import '../widgets/booking_request_card.dart';

class IncomingRideRequestScreen extends ConsumerWidget {
  const IncomingRideRequestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(availableBookingsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Incoming requests')),
      body: SafeArea(
        child: bookings.when(
          data: (requests) {
            if (requests.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: AppEmptyState(
                  icon: Icons.notifications_none,
                  title: 'No ride requests',
                  message:
                      'New requests will appear here while you are online.',
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(availableBookingsStreamProvider);
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  return BookingRequestCard(booking: requests[index]);
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppEmptyState(
              icon: Icons.error_outline,
              title: 'Could not load requests',
              message: error.toString(),
            ),
          ),
        ),
      ),
    );
  }
}

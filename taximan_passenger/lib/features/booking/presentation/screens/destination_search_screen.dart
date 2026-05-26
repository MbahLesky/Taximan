import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../auth/application/providers/auth_state_provider.dart';
import '../../application/providers/booking_providers.dart';
import '../../application/providers/booking_state_provider.dart';

class DestinationSearchScreen extends ConsumerStatefulWidget {
  const DestinationSearchScreen({super.key});

  @override
  ConsumerState<DestinationSearchScreen> createState() =>
      _DestinationSearchScreenState();
}

class _DestinationSearchScreenState
    extends ConsumerState<DestinationSearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingStateProvider);
    final passengerId = ref.watch(authStateProvider).userId;
    final recentBookings = passengerId == null
        ? null
        : ref.watch(recentBookingsProvider(passengerId)).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Destination')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppTextField(
            label: 'Search destination',
            hint: 'Where are you going?',
            icon: Icons.search,
            controller: _controller,
            textInputAction: TextInputAction.done,
            onChanged: (value) =>
                ref.read(bookingStateProvider.notifier).setDestination(value),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Row(
              children: [
                const Icon(Icons.route, color: AppColors.primaryDark),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Choose a destination to calculate distance, ETA, and fare before requesting a driver.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Recent from database',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...(recentBookings ?? const []).map(
            (booking) => AppCard(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.location_on_outlined),
                title: Text(booking.destination),
                subtitle: Text(
                  booking.estimatedFare > 0
                      ? booking.formattedFare
                      : 'Saved from booking history',
                ),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  ref
                      .read(bookingStateProvider.notifier)
                      .setDestinationFromBooking(booking);
                  context.push('/pickup-time');
                },
              ),
            ),
          ),
          if ((recentBookings ?? const []).isEmpty)
            AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.search),
                title: const Text('Enter a destination above'),
                subtitle: const Text(
                  'Database-backed recent destinations will appear after your first bookings.',
                ),
                trailing: const Icon(Icons.arrow_forward),
                onTap: bookingState.booking.destination.isEmpty
                    ? null
                    : () => context.push('/pickup-time'),
              ),
            ),
        ],
      ),
    );
  }
}

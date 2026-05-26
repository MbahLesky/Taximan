import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/ride_statuses.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../booking/application/providers/booking_providers.dart';
import '../../../booking/application/providers/booking_state_provider.dart';
import '../../application/providers/fare_proposal_providers.dart';
import '../../application/providers/matching_state_provider.dart';

class SearchingDriverScreen extends ConsumerWidget {
  const SearchingDriverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingId = ref.watch(bookingStateProvider).booking.id;
    final hasRealBooking = bookingId.isNotEmpty;

    if (hasRealBooking) {
      ref.listen(bookingStreamProvider(bookingId), (_, next) {
        final booking = next.valueOrNull;
        if (booking == null) {
          return;
        }
        if (booking.status == BookingStatus.accepted ||
            booking.status == BookingStatus.driverArriving) {
          ref.read(bookingStateProvider.notifier).setBooking(booking);
          context.push('/driver-assigned');
        }
      });

      ref.listen(pendingFareProposalProvider(bookingId), (_, next) {
        final proposal = next.valueOrNull;
        if (proposal == null) {
          return;
        }
        ref.read(matchingStateProvider.notifier).showFareProposal(proposal);
        context.push('/fare-proposal');
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Finding driver')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 124,
              height: 124,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Padding(
                padding: EdgeInsets.all(34),
                child: CircularProgressIndicator(color: AppColors.primaryDark),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Searching for nearby drivers',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'We are sending your request to available taxis around your pickup point.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const Spacer(),
            AppCard(
              child: Column(
                children: [
                  const _SearchStep(
                    icon: Icons.sensors,
                    label: 'Contacting nearby drivers',
                    active: true,
                  ),
                  const _SearchStep(
                    icon: Icons.payments_outlined,
                    label: 'Waiting for fare response',
                    active: true,
                  ),
                  const _SearchStep(
                    icon: Icons.verified_outlined,
                    label: 'Confirming best match',
                  ),
                  const Divider(height: 28),
                  AppButton(
                    label: 'Cancel search',
                    variant: AppButtonVariant.danger,
                    onPressed: () {
                      ref.read(matchingStateProvider.notifier).cancelSearch();
                      context.go('/home');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchStep extends StatelessWidget {
  const _SearchStep({
    required this.icon,
    required this.label,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(
            icon,
            color: active ? AppColors.success : AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/ride_statuses.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/models/booking.dart';
import '../../../../shared/models/fare_proposal.dart';
import '../../../../shared/utils/app_toast.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../matching/application/providers/driver_providers.dart';
import '../../../matching/application/providers/fare_proposal_providers.dart';
import '../../../trip/application/providers/trip_providers.dart';
import '../../application/providers/booking_providers.dart';
import '../../application/providers/booking_state_provider.dart';

class BookingDetailsScreen extends ConsumerStatefulWidget {
  const BookingDetailsScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  ConsumerState<BookingDetailsScreen> createState() =>
      _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends ConsumerState<BookingDetailsScreen> {
  String? _respondingProposalId;

  Future<void> _acceptProposal(Booking booking, FareProposal proposal) async {
    setState(() => _respondingProposalId = proposal.id);
    try {
      final tripId = await ref
          .read(fareProposalRepositoryProvider)
          .acceptProposal(proposal);
      ref
          .read(bookingStateProvider.notifier)
          .setBooking(
            booking.copyWith(
              driverId: proposal.driverId,
              vehicleId: proposal.vehicleId,
              finalFare: proposal.proposedFare,
              status: BookingStatus.accepted,
              acceptedAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
      _invalidatePassengerLists(booking.passengerId);

      if (!mounted) {
        return;
      }
      AppToast.success(
        context,
        title: 'Proposal accepted',
        description: 'Your upcoming trip has been created.',
      );
      context.push('/trip/$tripId');
    } catch (e) {
      if (mounted) {
        AppToast.error(
          context,
          title: 'Could not accept proposal',
          description: 'Check your connection and try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _respondingProposalId = null);
      }
    }
  }

  Future<void> _rejectProposal(Booking booking, FareProposal proposal) async {
    setState(() => _respondingProposalId = proposal.id);
    try {
      await ref.read(fareProposalRepositoryProvider).rejectProposal(proposal);
      _invalidatePassengerLists(booking.passengerId);

      if (mounted) {
        AppToast.success(
          context,
          title: 'Proposal rejected',
          description: 'The fare proposal has been cancelled.',
        );
      }
    } catch (e) {
      if (mounted) {
        AppToast.error(
          context,
          title: 'Could not reject proposal',
          description: 'Check your connection and try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _respondingProposalId = null);
      }
    }
  }

  void _invalidatePassengerLists(String passengerId) {
    if (passengerId.isEmpty) {
      return;
    }
    ref.invalidate(passengerBookingsProvider(passengerId));
    ref.invalidate(recentBookingsProvider(passengerId));
    ref.invalidate(passengerTripsProvider(passengerId));
    ref.invalidate(recentTripsProvider(passengerId));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bookingId.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Booking ID is missing.')),
      );
    }

    final bookingState = ref.watch(bookingStreamProvider(widget.bookingId));

    return bookingState.when(
      data: (booking) {
        if (booking == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Booking details'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(child: Text('Booking not found.')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Booking details')),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              _BookingSummaryCard(booking: booking),
              const SizedBox(height: AppSpacing.md),
              _RouteCard(booking: booking),
              const SizedBox(height: AppSpacing.md),
              _DriverPaymentCard(booking: booking),
              const SizedBox(height: AppSpacing.md),
              _FareProposalsSection(
                booking: booking,
                respondingProposalId: _respondingProposalId,
                onAccept: (proposal) => _acceptProposal(booking, proposal),
                onReject: (proposal) => _rejectProposal(booking, proposal),
              ),
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Booking details')),
        body: Center(child: Text('Failed to load booking: $error')),
      ),
    );
  }
}

class _BookingSummaryCard extends StatelessWidget {
  const _BookingSummaryCard({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${booking.pickupLocation} -> ${booking.destination}',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              Chip(
                label: Text(
                  booking.status,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Chip(label: Text(booking.paymentMethod)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DetailItem(
                  label: 'Estimated fare',
                  value: booking.formattedFare,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _DetailItem(label: 'Distance', value: booking.distance),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DetailItem(
                  label: 'ETA',
                  value: booking.eta.isEmpty ? 'TBD' : booking.eta,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _DetailItem(
                  label: 'Passengers',
                  value: '${booking.passengerCount}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pickup & destination',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.sm),
          _DetailsLine(label: 'Pickup', value: booking.pickupLocation),
          const SizedBox(height: AppSpacing.sm),
          _DetailsLine(label: 'Destination', value: booking.destination),
          const SizedBox(height: AppSpacing.sm),
          _DetailsLine(
            label: 'Pickup time',
            value: booking.pickupTimeType == 'now'
                ? 'Now'
                : booking.scheduledPickupTime == null
                ? 'Scheduled'
                : _formatDateTime(booking.scheduledPickupTime!),
          ),
          if (booking.additionalInfo.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            _DetailsLine(label: 'Notes', value: booking.additionalInfo),
          ],
        ],
      ),
    );
  }
}

class _DriverPaymentCard extends ConsumerWidget {
  const _DriverPaymentCard({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverId = booking.driverId ?? booking.preferredDriverId ?? '';
    final driver = driverId.isEmpty
        ? null
        : ref.watch(driverProvider(driverId)).valueOrNull;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Driver & payment',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.sm),
          _DetailsLine(
            label: 'Driver',
            value:
                driver?.fullName ??
                booking.preferredDriverName ??
                (driverId.isEmpty ? 'Unassigned' : 'Loading driver'),
          ),
          const SizedBox(height: AppSpacing.sm),
          _DetailsLine(label: 'Payment status', value: booking.paymentStatus),
          const SizedBox(height: AppSpacing.sm),
          _DetailsLine(label: 'Final fare', value: booking.formattedFinalFare),
        ],
      ),
    );
  }
}

class _FareProposalsSection extends ConsumerWidget {
  const _FareProposalsSection({
    required this.booking,
    required this.respondingProposalId,
    required this.onAccept,
    required this.onReject,
  });

  final Booking booking;
  final String? respondingProposalId;
  final ValueChanged<FareProposal> onAccept;
  final ValueChanged<FareProposal> onReject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proposals = ref.watch(bookingFareProposalsProvider(booking.id));

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fare proposals',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.sm),
          proposals.when(
            data: (items) {
              if (items.isEmpty) {
                return const Text(
                  'No fare proposals have been submitted for this booking.',
                  style: TextStyle(color: AppColors.textSecondary),
                );
              }

              return Column(
                children: [
                  for (final proposal in items) ...[
                    _ProposalCard(
                      booking: booking,
                      proposal: proposal,
                      isResponding: respondingProposalId == proposal.id,
                      onAccept: onAccept,
                      onReject: onReject,
                    ),
                    if (proposal != items.last) const Divider(height: 28),
                  ],
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text(
              'Failed to load fare proposals: $error',
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProposalCard extends ConsumerWidget {
  const _ProposalCard({
    required this.booking,
    required this.proposal,
    required this.isResponding,
    required this.onAccept,
    required this.onReject,
  });

  final Booking booking;
  final FareProposal proposal;
  final bool isResponding;
  final ValueChanged<FareProposal> onAccept;
  final ValueChanged<FareProposal> onReject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driver = proposal.driverId.isEmpty
        ? null
        : ref.watch(driverProvider(proposal.driverId)).valueOrNull;
    final bookingHasDriver = booking.driverId?.isNotEmpty == true;
    final canRespond = proposal.status == 'pending' && !bookingHasDriver;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(child: Icon(Icons.person_outline)),
          title: Text(driver?.fullName ?? 'Driver proposal'),
          subtitle: Text(
            driver == null
                ? proposal.driverId
                : 'Rating ${driver.rating.toStringAsFixed(1)}',
          ),
          trailing: Chip(label: Text(proposal.status)),
        ),
        _FareLine(
          label: 'Original fare',
          value: proposal.formattedOriginalFare,
        ),
        _FareLine(
          label: 'Proposed fare',
          value: proposal.formattedProposedFare,
          highlighted: true,
        ),
        if (proposal.message.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(proposal.message),
          ),
        ],
        if (canRespond) ...[
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Reject',
                  icon: Icons.close,
                  variant: AppButtonVariant.secondary,
                  isLoading: isResponding,
                  onPressed: isResponding ? null : () => onReject(proposal),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  label: 'Accept',
                  icon: Icons.check,
                  isLoading: isResponding,
                  onPressed: isResponding ? null : () => onAccept(proposal),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _FareLine extends StatelessWidget {
  const _FareLine({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: highlighted
                  ? AppColors.primaryDark
                  : AppColors.textPrimary,
              fontSize: highlighted ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsLine extends StatelessWidget {
  const _DetailsLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

String _formatDateTime(DateTime value) {
  return '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')} '
      '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/network_status_provider.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/utils/app_toast.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../auth/application/providers/auth_state_provider.dart';
import '../../application/providers/repositories.dart';
import '../../application/providers/booking_state_provider.dart';

class RideSummaryScreen extends ConsumerStatefulWidget {
  const RideSummaryScreen({super.key});

  @override
  ConsumerState<RideSummaryScreen> createState() => _RideSummaryScreenState();
}

class _RideSummaryScreenState extends ConsumerState<RideSummaryScreen> {
  Future<void> _confirmRide() async {
    final authState = ref.read(authStateProvider);
    final networkStatus = ref.read(networkStatusProvider);
    if (networkStatus.isOffline) {
      AppToast.warning(
        context,
        title: 'No internet connection',
        description: 'Reconnect before requesting a ride.',
      );
      return;
    }

    final passengerId = authState.userId;
    if (passengerId == null) {
      context.go('/login');
      return;
    }

    final bookingController = ref.read(bookingStateProvider.notifier);
    bookingController.markSearching();

    try {
      final draft = ref
          .read(bookingStateProvider)
          .booking
          .copyWith(passengerId: passengerId);
      final booking = await ref
          .read(bookingRepositoryProvider)
          .createBooking(draft);
      bookingController.setBooking(booking);
      if (mounted) {
        AppToast.success(
          context,
          title: 'Ride request sent',
          description: 'Drivers can now respond to your ride request.',
        );
        context.go('/home');
      }
    } catch (e) {
      bookingController.setError('Could not create booking. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(bookingStateProvider, (previous, next) {
      final message = next.errorMessage;
      if (message != null && message != previous?.errorMessage) {
        AppToast.error(
          context,
          title: 'Booking error',
          description: message,
        );
      }
    });

    final bookingState = ref.watch(bookingStateProvider);
    final networkStatus = ref.watch(networkStatusProvider);
    final booking = bookingState.booking;

    return Scaffold(
      appBar: AppBar(title: const Text('Ride summary')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Container(
            height: 170,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: _SummaryMapPainter()),
                ),
                const Positioned(
                  left: 52,
                  top: 54,
                  child: Icon(
                    Icons.my_location,
                    color: AppColors.info,
                    size: 28,
                  ),
                ),
                const Positioned(
                  right: 52,
                  bottom: 44,
                  child: Icon(
                    Icons.location_on,
                    color: AppColors.error,
                    size: 34,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              children: [
                _RouteRow(
                  pickup: booking.pickupLocation,
                  destination: booking.destination,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fare and route',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  booking.estimatedFare > 0
                      ? booking.formattedFare
                      : 'Pending driver proposal',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Divider(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _MetricTile(
                        icon: Icons.route,
                        label: 'Distance',
                        value: booking.distance,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _MetricTile(
                        icon: Icons.timer_outlined,
                        label: 'ETA',
                        value: booking.eta,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _MetricRow(label: 'Payment', value: booking.paymentMethod),
                _MetricRow(
                  label: 'Proposed pay',
                  value: booking.proposedFareAmount > 0
                      ? booking.formattedProposedFare
                      : 'Use estimate',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ride details',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                _MetricRow(
                  label: 'Pickup time',
                  value: booking.pickupTimeType == 'now'
                      ? 'Now'
                      : booking.scheduledPickupTime == null
                      ? 'Scheduled'
                      : _formatDateTime(booking.scheduledPickupTime!),
                ),
                _MetricRow(
                  label: 'Ride sharing',
                  value: booking.isRideSharing ? 'Allowed' : 'Private ride',
                ),
                _MetricRow(
                  label: 'Passengers',
                  value: booking.passengerCount.toString(),
                ),
                _MetricRow(
                  label: 'Luggage',
                  value: booking.hasLuggage
                      ? '${booking.luggageCount} piece(s)'
                      : 'None',
                ),
                _MetricRow(
                  label: 'Driver',
                  value: booking.preferredDriverName?.isNotEmpty == true
                      ? booking.preferredDriverName!
                      : 'Auto-match',
                ),
                if (booking.additionalInfo.isNotEmpty) ...[
                  const Divider(height: 28),
                  Text(
                    'Additional info',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(booking.additionalInfo),
                ],
              ],
            ),
          ),
          if (networkStatus.isOffline) ...[
            const SizedBox(height: AppSpacing.md),
            const AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.wifi_off, color: AppColors.error),
                title: Text('No internet connection'),
                subtitle: Text('Reconnect before requesting a ride.'),
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(AppSpacing.md),
        child: AppButton(
          label: 'Request ride',
          icon: Icons.local_taxi_outlined,
          isLoading: bookingState.isLoading,
          onPressed: bookingState.canConfirmRide && networkStatus.isOnline
              ? _confirmRide
              : null,
        ),
      ),
    );
  }
}

String _formatDateTime(DateTime value) {
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '${value.day}/${value.month}/${value.year} at $hour:$minute';
}

class _SummaryMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.72)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    final routePaint = Paint()
      ..color = AppColors.primaryDark
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(24, size.height * .72),
      Offset(size.width - 32, 38),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * .12, 42),
      Offset(size.width * .88, size.height - 36),
      roadPaint,
    );
    canvas.drawLine(
      Offset(68, 72),
      Offset(size.width - 68, size.height - 56),
      routePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RouteRow extends StatelessWidget {
  const _RouteRow({required this.pickup, required this.destination});

  final String pickup;
  final String destination;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const Icon(Icons.my_location, size: 20, color: AppColors.info),
            Container(width: 2, height: 34, color: AppColors.border),
            const Icon(Icons.location_on, size: 22, color: AppColors.error),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pickup',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              Text(pickup, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Destination',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              Text(
                destination,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryDark),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
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
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

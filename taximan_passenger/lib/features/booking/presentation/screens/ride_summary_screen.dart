import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../application/providers/booking_state_provider.dart';

class RideSummaryScreen extends ConsumerStatefulWidget {
  const RideSummaryScreen({super.key});

  @override
  ConsumerState<RideSummaryScreen> createState() => _RideSummaryScreenState();
}

class _RideSummaryScreenState extends ConsumerState<RideSummaryScreen> {
  bool rideSharing = false;

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingStateProvider);
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
                  'Estimated fare',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  booking.formattedFare,
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
                _MetricRow(label: 'Driver fare proposal', value: 'Allowed'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: rideSharing,
              activeColor: AppColors.primaryDark,
              title: const Text('Ride sharing'),
              subtitle: const Text(
                'Share this trip with another passenger when available.',
              ),
              onChanged: (value) => setState(() => rideSharing = value),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.info_outline, color: AppColors.info),
              title: Text('Fare can be negotiated'),
              subtitle: Text(
                'A nearby driver may accept the estimate or send a different fare proposal.',
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(AppSpacing.md),
        child: AppButton(
          label: 'Confirm Ride',
          icon: Icons.local_taxi_outlined,
          isLoading: bookingState.isLoading,
          onPressed: bookingState.canConfirmRide
              ? () {
                  ref.read(bookingStateProvider.notifier).markSearching();
                  context.push('/searching-driver');
                }
              : null,
        ),
      ),
    );
  }
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

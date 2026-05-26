import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../auth/application/providers/auth_state_provider.dart';
import '../../../account/application/providers/user_provider.dart';
import '../../../matching/application/providers/driver_providers.dart';
import '../../application/providers/booking_providers.dart';
import '../../application/providers/booking_state_provider.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';

class PassengerHomeScreen extends ConsumerWidget {
  const PassengerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).valueOrNull;
    final passengerId = ref.watch(authStateProvider).userId;
    final availableDriverCount = ref.watch(availableDriverCountProvider);
    final recentBookings = passengerId == null
        ? null
        : ref.watch(recentBookingsProvider(passengerId)).valueOrNull;
    final bookingState = ref.watch(bookingStateProvider);
    final booking = bookingState.booking;
    final firstName = currentUser?.fullName.split(' ').first;

    return BottomNavShell(
      currentIndex: 0,
      title: 'Home Dashboard',
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstName == null || firstName.isEmpty
                            ? 'Good morning'
                            : 'Good morning, $firstName',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Plan your ride',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: () => context.go('/profile'),
                  icon: const Icon(Icons.person_outline),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.local_taxi,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ready when you are',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        availableDriverCount.when(
                          data: (count) => Text(
                            '$count online drivers available',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          loading: () => const Text(
                            'Checking driver availability...',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          error: (_, _) => const Text(
                            'Driver availability unavailable',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/drivers'),
                    child: const Text('View'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: _LocationTile(
                icon: Icons.my_location,
                title: 'Current Location',
                value: booking.pickupLocation.isEmpty
                    ? 'Set pickup location'
                    : booking.pickupLocation,
                onTap: () => context.push('/pickup'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              height: 210,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: _MapPlaceholderPainter()),
                  ),
                  const Positioned(
                    top: 88,
                    left: 72,
                    child: Icon(
                      Icons.my_location,
                      color: AppColors.info,
                      size: 28,
                    ),
                  ),
                  const Positioned(
                    right: 76,
                    bottom: 84,
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.error,
                      size: 34,
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: IconButton.filled(
                      tooltip: 'Use current location',
                      onPressed: () => context.push('/pickup'),
                      icon: const Icon(Icons.gps_fixed),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.compact,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.sensors,
                            size: 16,
                            color: AppColors.success,
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Text(
                            'Location active',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LocationTile(
                    icon: Icons.search,
                    title: 'Where are you going?',
                    value: booking.destination.isEmpty
                        ? 'Select destination'
                        : booking.destination,
                    onTap: () => context.push('/pickup'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: booking.destination.isEmpty
                        ? 'Plan route'
                        : 'Change route',
                    icon: Icons.arrow_forward,
                    onPressed: () => context.push('/pickup'),
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
                    'Ride action',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Row(
                    children: [
                      Expanded(
                        child: _ActionPill(
                          icon: Icons.flash_on,
                          label: 'Ride now',
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _ActionPill(
                          icon: Icons.schedule,
                          label: 'Schedule',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionPill(
                          icon: Icons.payments_outlined,
                          label: booking.paymentMethod,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _ActionPill(
                          icon: Icons.group_outlined,
                          label: 'Ride share',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: 'Review ride summary',
                    icon: Icons.receipt_long_outlined,
                    onPressed: bookingState.canConfirmRide
                        ? () => context.push('/ride-summary')
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Recent destinations',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/trips'),
                  child: const Text('Trips'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ...(recentBookings ?? const []).map(
              (recentBooking) => AppCard(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.history),
                  title: Text(recentBooking.destination),
                  subtitle: Text(recentBooking.pickupLocation),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ref
                        .read(bookingStateProvider.notifier)
                        .setDestinationFromBooking(recentBooking);
                    context.push('/destination');
                  },
                ),
              ),
            ),
            if ((recentBookings ?? const []).isEmpty)
              AppCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.history_toggle_off),
                  title: const Text('No recent destinations yet'),
                  subtitle: const Text(
                    'Completed bookings from the database will appear here.',
                  ),
                  onTap: () => context.push('/pickup'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.compact,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: AppColors.primaryDark),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  const _LocationTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _MapPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    final smallRoadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(24, size.height * .28),
      Offset(size.width - 38, size.height * .68),
      roadPaint,
    );
    canvas.drawLine(
      Offset(40, size.height * .78),
      Offset(size.width * .72, 30),
      smallRoadPaint,
    );
    canvas.drawLine(
      Offset(size.width * .15, 48),
      Offset(size.width * .92, size.height * .24),
      smallRoadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

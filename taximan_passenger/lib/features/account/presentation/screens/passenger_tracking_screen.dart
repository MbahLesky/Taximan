import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';

class PassengerTrackingScreen extends StatelessWidget {
  const PassengerTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavShell(
      currentIndex: 3,
      title: 'Tracking',
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: _TrackingMapPainter()),
                  ),
                  const Positioned(
                    top: 44,
                    left: 58,
                    child: _MapPin(
                      icon: Icons.person_pin_circle,
                      color: AppColors.info,
                    ),
                  ),
                  const Positioned(
                    right: 64,
                    bottom: 58,
                    child: _MapPin(
                      icon: Icons.local_taxi,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  Positioned(
                    right: 16,
                    top: 16,
                    child: Chip(
                      backgroundColor: AppColors.surface,
                      side: const BorderSide(color: AppColors.border),
                      avatar: const Icon(
                        Icons.sensors,
                        size: 18,
                        color: AppColors.success,
                      ),
                      label: const Text('Live'),
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
                  Row(
                    children: [
                      const Icon(Icons.near_me, color: AppColors.primaryDark),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Current trip status',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      const Chip(
                        visualDensity: VisualDensity.compact,
                        backgroundColor: AppColors.primaryLight,
                        side: BorderSide.none,
                        label: Text('Arriving'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const _TimelineStep(
                    icon: Icons.check_circle,
                    title: 'Ride accepted',
                    subtitle: '${DummyData.driverName} confirmed your request.',
                    active: true,
                  ),
                  const _TimelineStep(
                    icon: Icons.local_taxi,
                    title: 'Driver on the way',
                    subtitle: 'ETA ${DummyData.eta} to your pickup point.',
                    active: true,
                  ),
                  const _TimelineStep(
                    icon: Icons.flag_outlined,
                    title: 'Pickup pending',
                    subtitle: 'You will be notified when the driver arrives.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                children: [
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryLight,
                      child: Icon(Icons.person, color: AppColors.primaryDark),
                    ),
                    title: Text(DummyData.driverName),
                    subtitle: Text(
                      '${DummyData.vehicleName} - ${DummyData.vehiclePlate}',
                    ),
                    trailing: Icon(Icons.star, color: AppColors.warning),
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Open live trip',
                          icon: Icons.map_outlined,
                          onPressed: () => context.push('/driver-en-route'),
                        ),
                      ),
                    ],
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

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.active = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: active ? AppColors.success : AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(icon, color: color),
    );
  }
}

class _TrackingMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final routePaint = Paint()
      ..color = AppColors.primaryDark.withValues(alpha: 0.18)
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;
    final activePaint = Paint()
      ..color = AppColors.primaryDark
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.72)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(28, size.height * .78),
      Offset(size.width * .86, 42),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * .12, 54),
      Offset(size.width - 32, size.height * .72),
      roadPaint,
    );
    canvas.drawLine(
      Offset(78, 72),
      Offset(size.width - 86, size.height - 76),
      routePaint,
    );
    canvas.drawLine(
      Offset(78, 72),
      Offset(size.width * .58, size.height * .54),
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

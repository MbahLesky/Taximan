import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';

class PassengerHomeScreen extends StatelessWidget {
  const PassengerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavShell(
      currentIndex: 0,
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
                      Text('Hello, ${DummyData.passengerName}', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Where are you going?',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
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
            Container(
              height: 270,
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
                    child: Icon(Icons.my_location, color: AppColors.info, size: 28),
                  ),
                  const Positioned(
                    right: 76,
                    bottom: 84,
                    child: Icon(Icons.location_on, color: AppColors.error, size: 34),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(Icons.gps_fixed),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                children: [
                  _LocationTile(
                    icon: Icons.my_location,
                    title: 'Current location',
                    value: DummyData.pickupLocation,
                    onTap: () => context.go('/pickup'),
                  ),
                  const Divider(height: 24),
                  _LocationTile(
                    icon: Icons.search,
                    title: 'Destination',
                    value: 'Where are you going?',
                    onTap: () => context.go('/destination'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: 'Plan a ride',
                    icon: Icons.arrow_forward,
                    onPressed: () => context.go('/destination'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Quick actions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: DummyData.quickActions
                  .map(
                    (action) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: AppCard(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Center(
                            child: Text(action, style: const TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Recent destinations', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.sm),
            ...DummyData.recentDestinations.map(
              (destination) => AppCard(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.history),
                  title: Text(destination),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/pickup-time'),
                ),
              ),
            ),
          ],
        ),
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
      title: Text(title, style: const TextStyle(color: AppColors.textSecondary)),
      subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _MapPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    final smallRoadPaint = Paint()
      ..color = Colors.white.withOpacity(0.55)
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(24, size.height * .28), Offset(size.width - 38, size.height * .68), roadPaint);
    canvas.drawLine(Offset(40, size.height * .78), Offset(size.width * .72, 30), smallRoadPaint);
    canvas.drawLine(Offset(size.width * .15, 48), Offset(size.width * .92, size.height * .24), smallRoadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

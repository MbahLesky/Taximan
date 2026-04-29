import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

class DriverAssignedScreen extends StatelessWidget {
  const DriverAssignedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver assigned')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(Icons.person, size: 40, color: AppColors.primaryDark),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(DummyData.driverName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: AppSpacing.xs),
                const Text('Rating ${DummyData.driverRating}'),
                const Divider(height: 32),
                const _InfoLine(icon: Icons.local_taxi, label: 'Vehicle', value: DummyData.vehicleName),
                const _InfoLine(icon: Icons.pin, label: 'Plate number', value: DummyData.vehiclePlate),
                const _InfoLine(icon: Icons.timer_outlined, label: 'Arrival ETA', value: DummyData.eta),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'Continue tracking', onPressed: () => context.go('/driver-en-route')),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label, style: const TextStyle(color: AppColors.textSecondary)),
      trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}

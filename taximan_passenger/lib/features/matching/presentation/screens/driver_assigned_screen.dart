import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../trip/application/providers/trip_state_provider.dart';

class DriverAssignedScreen extends ConsumerWidget {
  const DriverAssignedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driver = ref.watch(tripStateProvider).assignedDriver;

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
                Text(driver?.fullName ?? 'Driver assigned', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(5, (index) => const Icon(Icons.star, size: 18, color: AppColors.warning)),
                    const SizedBox(width: AppSpacing.xs),
                    Text('${driver?.rating.toStringAsFixed(1) ?? '4.8'} rating'),
                  ],
                ),
                const Divider(height: 32),
                _InfoLine(icon: Icons.local_taxi, label: 'Vehicle', value: driver?.vehicle ?? ''),
                _InfoLine(icon: Icons.pin, label: 'Plate number', value: driver?.plateNumber ?? ''),
                _InfoLine(icon: Icons.timer_outlined, label: 'Arrival ETA', value: driver?.arrivalEta ?? ''),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Call',
                        icon: Icons.call_outlined,
                        variant: AppButtonVariant.secondary,
                        onPressed: null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppButton(
                        label: 'Message',
                        icon: Icons.message_outlined,
                        variant: AppButtonVariant.secondary,
                        onPressed: null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'Continue tracking', onPressed: () => context.push('/driver-en-route')),
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

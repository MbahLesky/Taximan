import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../onboarding/application/providers/driver_providers.dart';

class VehicleInformationScreen extends ConsumerWidget {
  const VehicleInformationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driver = ref.watch(currentDriverProvider).valueOrNull;
    final vehicle = driver?.vehicle;

    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle information')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: Column(
              children: [
                _VehicleLine(label: 'Vehicle type', value: vehicle?.type ?? ''),
                _VehicleLine(label: 'Make/model', value: vehicle?.model ?? ''),
                _VehicleLine(
                  label: 'Plate number',
                  value: vehicle?.plateNumber ?? '',
                ),
                _VehicleLine(label: 'Color', value: vehicle?.color ?? ''),
                _VehicleLine(
                  label: 'Capacity',
                  value: vehicle == null ? '' : '${vehicle.capacity}',
                ),
                _VehicleLine(
                  label: 'Document status',
                  value: _verificationLabel(
                    driver?.verificationStatus ?? 'pending',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleLine extends StatelessWidget {
  const _VehicleLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }
}

String _verificationLabel(String status) {
  return switch (status.toLowerCase()) {
    'approved' => 'Approved',
    'rejected' => 'Rejected',
    'suspended' => 'Suspended',
    'not_submitted' => 'Not submitted',
    _ => 'Pending verification',
  };
}

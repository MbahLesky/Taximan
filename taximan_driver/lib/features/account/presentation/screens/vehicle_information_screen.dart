import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_card.dart';

class VehicleInformationScreen extends StatelessWidget {
  const VehicleInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle information')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: const [
          AppCard(
            child: Column(
              children: [
                _VehicleLine(
                  label: 'Vehicle type',
                  value: DummyData.vehicleType,
                ),
                _VehicleLine(
                  label: 'Make/model',
                  value: DummyData.vehicleModel,
                ),
                _VehicleLine(
                  label: 'Plate number',
                  value: DummyData.vehiclePlate,
                ),
                _VehicleLine(label: 'Color', value: DummyData.vehicleColor),
                _VehicleLine(
                  label: 'Capacity',
                  value: DummyData.vehicleCapacity,
                ),
                _VehicleLine(
                  label: 'Document status',
                  value: DummyData.verificationStatus,
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

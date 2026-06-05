import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/models/vehicle.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../auth/application/providers/auth_state_provider.dart';
import '../../application/providers/driver_providers.dart';

class VehicleDetailsScreen extends ConsumerStatefulWidget {
  const VehicleDetailsScreen({super.key});

  @override
  ConsumerState<VehicleDetailsScreen> createState() =>
      _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends ConsumerState<VehicleDetailsScreen> {
  String _type = '';
  String _model = '';
  String _plateNumber = '';
  String _color = '';
  String _capacity = '';
  bool _isSaving = false;

  Future<void> _save() async {
    final driverId = ref.read(authStateProvider).userId;
    final capacity = int.tryParse(_capacity.trim());

    if (driverId == null) {
      _showMessage('Sign in before continuing onboarding.');
      return;
    }
    if (_type.trim().isEmpty ||
        _model.trim().isEmpty ||
        _plateNumber.trim().isEmpty ||
        _color.trim().isEmpty ||
        capacity == null ||
        capacity <= 0) {
      _showMessage('Complete all vehicle details with a valid capacity.');
      return;
    }

    setState(() => _isSaving = true);
    try {
      await ref
          .read(driverRepositoryProvider)
          .saveVehicle(
            driverId: driverId,
            vehicle: Vehicle(
              type: _type,
              model: _model,
              plateNumber: _plateNumber,
              color: _color,
              capacity: capacity,
            ),
          );
      if (mounted) {
        context.push('/document-upload');
      }
    } catch (e) {
      _showMessage('Could not save vehicle details. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle details')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppTextField(
            label: 'Vehicle type',
            hint: 'Taxi',
            icon: Icons.local_taxi,
            onChanged: (value) => _type = value,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Make and model',
            hint: 'Toyota Corolla',
            icon: Icons.directions_car,
            onChanged: (value) => _model = value,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Plate number',
            hint: 'NW-123-AB',
            icon: Icons.pin,
            onChanged: (value) => _plateNumber = value,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Vehicle color',
            hint: 'Yellow',
            icon: Icons.palette_outlined,
            onChanged: (value) => _color = value,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Capacity',
            hint: '4',
            icon: Icons.groups_outlined,
            keyboardType: TextInputType.number,
            onChanged: (value) => _capacity = value,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'Continue', isLoading: _isSaving, onPressed: _save),
        ],
      ),
    );
  }
}

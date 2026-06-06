import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../auth/application/providers/auth_state_provider.dart';
import '../../application/providers/driver_providers.dart';

class DriverPersonalInfoScreen extends ConsumerStatefulWidget {
  const DriverPersonalInfoScreen({super.key});

  @override
  ConsumerState<DriverPersonalInfoScreen> createState() =>
      _DriverPersonalInfoScreenState();
}

class _DriverPersonalInfoScreenState
    extends ConsumerState<DriverPersonalInfoScreen> {
  String _city = '';
  bool _isSaving = false;

  Future<void> _save() async {
    final driverId = ref.read(authStateProvider).userId;
    if (driverId == null) {
      _showMessage('Sign in before continuing onboarding.');
      return;
    }
    if (_city.trim().isEmpty) {
      _showMessage('Enter your city.');
      return;
    }

    setState(() => _isSaving = true);
    try {
      await ref
          .read(driverRepositoryProvider)
          .updatePersonalInfo(
            driverId: driverId,
            city: _city,
          );
      if (mounted) {
        context.push('/vehicle-details');
      }
    } catch (e) {
      _showMessage('Could not save your profile. Please try again.');
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
      appBar: AppBar(title: const Text('Personal information')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppTextField(
            label: 'City or location',
            icon: Icons.location_city_outlined,
            onChanged: (value) => _city = value,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'Continue', isLoading: _isSaving, onPressed: _save),
        ],
      ),
    );
  }
}

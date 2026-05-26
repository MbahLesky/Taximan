import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../application/providers/booking_state_provider.dart';

class PickupLocationScreen extends ConsumerStatefulWidget {
  const PickupLocationScreen({super.key});

  @override
  ConsumerState<PickupLocationScreen> createState() =>
      _PickupLocationScreenState();
}

class _PickupLocationScreenState extends ConsumerState<PickupLocationScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booking = ref.watch(bookingStateProvider).booking;

    return Scaffold(
      appBar: AppBar(title: const Text('Pickup location')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Icon(
                Icons.my_location,
                size: 56,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.my_location),
              title: const Text('Current pickup'),
              subtitle: Text(
                booking.pickupLocation.isEmpty
                    ? 'Enter a pickup point'
                    : booking.pickupLocation,
              ),
              trailing: const Chip(
                visualDensity: VisualDensity.compact,
                backgroundColor: AppColors.primaryLight,
                side: BorderSide.none,
                label: Text('Detected'),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Edit pickup point',
            hint: 'Enter street, quarter, or landmark',
            icon: Icons.edit_location_alt_outlined,
            controller: _controller,
            onChanged: (value) =>
                ref.read(bookingStateProvider.notifier).setPickup(value),
          ),
          const SizedBox(height: AppSpacing.md),
          const AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.info_outline),
              title: Text('Pickup points are saved with each booking'),
              subtitle: Text('Recent database locations appear on the home screen.'),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Confirm pickup',
            onPressed:
                booking.pickupLocation.isEmpty ? null : () => context.push('/destination'),
          ),
        ],
      ),
    );
  }
}

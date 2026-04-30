import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../application/providers/booking_state_provider.dart';

class PickupLocationScreen extends ConsumerWidget {
  const PickupLocationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingStateProvider).booking;

    return Scaffold(
      appBar: AppBar(title: const Text('Pickup location')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.my_location),
              title: const Text('Current pickup'),
              subtitle: Text(booking.pickupLocation),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const AppTextField(
            label: 'Edit pickup point',
            hint: 'Enter street, quarter, or landmark',
            icon: Icons.edit_location_alt_outlined,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'Confirm pickup', onPressed: () => context.push('/destination')),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../core/constants/app_colors.dart';
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
              subtitle: Text(booking.pickupLocation),
              trailing: const Chip(
                visualDensity: VisualDensity.compact,
                backgroundColor: AppColors.primaryLight,
                side: BorderSide.none,
                label: Text('Detected'),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const AppTextField(
            label: 'Edit pickup point',
            hint: 'Enter street, quarter, or landmark',
            icon: Icons.edit_location_alt_outlined,
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              children: const [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.place_outlined),
                  title: Text('Use nearby landmark'),
                  subtitle: Text('Mvan Carrefour, Yaounde'),
                  trailing: Icon(Icons.chevron_right),
                ),
                Divider(height: 1),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.home_outlined),
                  title: Text('Saved pickup'),
                  subtitle: Text('Home address'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Confirm pickup',
            onPressed: () => context.push('/destination'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../account/application/driver_payment_pin_provider.dart';
import '../widgets/driver_payment_pin_dialog.dart';
import '../../../auth/application/providers/auth_state_provider.dart';

class DriverSettingsScreen extends ConsumerWidget {
  const DriverSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinState = ref.watch(driverPaymentPinProvider);
    final pinTitle = pinState.when(
      data: (pin) => pin?.isNotEmpty == true ? 'Payment PIN' : 'Set payment PIN',
      loading: () => 'Payment PIN',
      error: (_, __) => 'Payment PIN',
    );
    final pinSubtitle = pinState.when(
      data: (pin) => pin?.isNotEmpty == true
          ? 'Use your PIN to confirm payments and secure cash collection.'
          : 'Create a payment PIN for driver-side cash collection.',
      loading: () => 'Loading payment PIN status...',
      error: (_, __) => 'Unable to load payment PIN status.',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: Column(
              children: [
                const _SettingsTile(
                  icon: Icons.person_outline,
                  title: 'Account settings',
                  subtitle: 'Profile and driver account',
                ),
                const _SettingsTile(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: 'English',
                ),
                const _SettingsTile(
                  icon: Icons.contrast,
                  title: 'Theme',
                  subtitle: 'Light',
                ),
                const _SettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Ride request alerts enabled',
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.pin, color: AppColors.primaryDark),
                  title: Text(pinTitle),
                  subtitle: Text(pinSubtitle),
                  trailing: pinState.isLoading
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.chevron_right),
                  onTap: () async {
                    await showDriverPinSetupDialog(context, ref);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Logout',
            variant: AppButtonVariant.danger,
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
              if (context.mounted) {
                context.go('/onboarding');
              }
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primaryDark),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

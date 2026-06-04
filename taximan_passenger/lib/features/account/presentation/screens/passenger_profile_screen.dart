import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/notification_settings_provider.dart';
import '../../../../core/providers/theme_mode_provider.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/models/user.dart';
import '../../application/providers/user_provider.dart';
import '../../../auth/application/providers/auth_state_provider.dart';
import '../../../notifications/application/providers/notification_state_provider.dart';
import '../../../../shared/utils/app_toast.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';

class PassengerProfileScreen extends ConsumerWidget {
  const PassengerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? user = ref.watch(currentUserProvider).valueOrNull;
    final themeMode = ref.watch(themeModeProvider);
    final notificationSettings = ref.watch(notificationSettingsProvider);
    final unreadCount = ref.watch(notificationStateProvider).unreadCount;

    return BottomNavShell(
      currentIndex: 4,
      title: 'Profile',
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AppCard(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 42,
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(
                      Icons.person,
                      size: 46,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    user?.fullName ?? 'Passenger profile',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _ProfileLine(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: user?.phone ?? '',
                  ),
                  _ProfileLine(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: user?.email ?? '',
                  ),
                  _ProfileLine(
                    icon: Icons.payments_outlined,
                    label: 'Preferred payment',
                    value: user?.defaultPaymentMethod ?? '',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: 'Edit profile',
                    icon: Icons.edit_outlined,
                    variant: AppButtonVariant.secondary,
                    onPressed: user == null
                        ? null
                        : () => _showEditProfileDialog(context, ref, user),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                children: [
                  const _SettingsTile(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: 'English',
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.contrast,
                      color: AppColors.primaryDark,
                    ),
                    title: const Text(
                      'Theme',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      themeMode == ThemeMode.dark ? 'Dark' : 'Light',
                    ),
                    trailing: Switch.adaptive(
                      value: themeMode == ThemeMode.dark,
                      onChanged: (value) => ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(
                            value ? ThemeMode.dark : ThemeMode.light,
                          ),
                    ),
                    onTap: () =>
                        ref.read(themeModeProvider.notifier).toggleThemeMode(),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.primaryDark,
                    ),
                    title: const Text(
                      'Notifications',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      notificationSettings.enabled
                          ? 'Enabled${unreadCount > 0 ? ' · $unreadCount unread' : ''}'
                          : 'Disabled',
                    ),
                    trailing: Switch.adaptive(
                      value: notificationSettings.enabled,
                      onChanged: (value) => ref
                          .read(notificationSettingsProvider.notifier)
                          .setEnabled(value),
                    ),
                    onTap: () => context.go('/notifications'),
                  ),
                  const _SettingsTile(
                    icon: Icons.location_on_outlined,
                    title: 'Location access',
                    subtitle: 'Used while booking and tracking',
                  ),
                  const _SettingsTile(
                    icon: Icons.support_agent_outlined,
                    title: 'Help and support',
                    subtitle: 'Trip issues and safety support',
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.local_taxi_outlined,
                      color: AppColors.primaryDark,
                    ),
                    title: const Text(
                      'Saved drivers',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: const Text('View and manage saved drivers'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go('/saved-drivers'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Logout',
              icon: Icons.logout,
              variant: AppButtonVariant.danger,
              onPressed: () async {
                await ref.read(authStateProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditProfileDialog(
    BuildContext context,
    WidgetRef ref,
    User user,
  ) async {
    final fullNameController = TextEditingController(text: user.fullName);
    final phoneController = TextEditingController(text: user.phone);
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit profile'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: fullNameController,
                  decoration: const InputDecoration(labelText: 'Full name'),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your phone number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                if (!(formKey.currentState?.validate() ?? false)) {
                  return;
                }

                final updatedName = fullNameController.text.trim();
                final updatedPhone = phoneController.text.trim();

                if (updatedName == user.fullName &&
                    updatedPhone == user.phone) {
                  Navigator.of(context).pop();
                  return;
                }

                try {
                  await ref
                      .read(userRepositoryProvider)
                      .updateUser(
                        user.id,
                        fullName: updatedName,
                        phone: updatedPhone,
                      );

                  if (!context.mounted) {
                    return;
                  }

                  AppToast.success(
                    context,
                    title: 'Profile updated',
                    description: 'Your name and phone number were saved.',
                  );
                  Navigator.of(context).pop();
                } catch (error) {
                  if (!context.mounted) {
                    return;
                  }

                  AppToast.error(
                    context,
                    title: 'Update failed',
                    description: error.toString(),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileLine extends StatelessWidget {
  const _ProfileLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(
        label,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w700),
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
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

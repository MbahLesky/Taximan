import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create driver account')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const AppTextField(label: 'Full name', icon: Icons.badge_outlined),
          const SizedBox(height: AppSpacing.md),
          const AppTextField(label: 'Email', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: AppSpacing.md),
          const AppTextField(label: 'Phone', icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
          const SizedBox(height: AppSpacing.md),
          const AppTextField(label: 'Password', icon: Icons.lock_outline, obscureText: true),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'Register', onPressed: () => context.go('/driver-personal-info')),
          const SizedBox(height: AppSpacing.md),
          TextButton(onPressed: () => context.go('/login'), child: const Text('Already have an account? Login')),
        ],
      ),
    );
  }
}

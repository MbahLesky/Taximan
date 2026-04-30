import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Text(
              'Welcome back',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text('Use any details for this UI prototype.', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.xl),
            const AppTextField(label: 'Email or phone', icon: Icons.person_outline),
            const SizedBox(height: AppSpacing.md),
            const AppTextField(label: 'Password', icon: Icons.lock_outline, obscureText: true),
            const SizedBox(height: AppSpacing.xl),
            AppButton(label: 'Login', onPressed: () => context.go('/home')),
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: () => context.push('/register'),
              child: const Text('Create a passenger account'),
            ),
          ],
        ),
      ),
    );
  }
}

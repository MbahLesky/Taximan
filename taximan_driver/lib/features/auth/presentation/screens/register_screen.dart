import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../application/providers/auth_state_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  String _fullName = '';
  String _email = '';
  String _phone = '';
  String _password = '';

  Future<void> _register() async {
    if (_fullName.trim().isEmpty ||
        _email.trim().isEmpty ||
        _phone.trim().isEmpty ||
        _password.isEmpty) {
      _showMessage('Complete all fields to create your driver account.');
      return;
    }

    try {
      await ref
          .read(authStateProvider.notifier)
          .registerDriver(
            fullName: _fullName,
            email: _email,
            phone: _phone,
            password: _password,
          );
      if (mounted) {
        context.go('/driver-personal-info');
      }
    } catch (_) {
      final message =
          ref.read(authStateProvider).errorMessage ??
          'Could not create your account. Please try again.';
      _showMessage(message);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create driver account')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Create your driver login',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Personal and vehicle details come next.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppTextField(
            label: 'Full name',
            icon: Icons.badge_outlined,
            onChanged: (value) => _fullName = value,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => _email = value,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Phone',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            onChanged: (value) => _phone = value,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Password',
            icon: Icons.lock_outline,
            obscureText: true,
            onChanged: (value) => _password = value,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Continue',
            isLoading: authState.isLoading,
            onPressed: _register,
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => context.push('/login'),
            child: const Text('Already have an account? Login'),
          ),
        ],
      ),
    );
  }
}

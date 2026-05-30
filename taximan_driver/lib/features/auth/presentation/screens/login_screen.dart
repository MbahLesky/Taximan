import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../application/providers/auth_state_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String _email = '';
  String _password = '';

  Future<void> _login() async {
    if (_email.trim().isEmpty || _password.isEmpty) {
      _showMessage('Enter your email and password.');
      return;
    }

    try {
      await ref
          .read(authStateProvider.notifier)
          .login(email: _email, password: _password);
      if (mounted) {
        context.go('/dashboard');
      }
    } catch (_) {
      final message =
          ref.read(authStateProvider).errorMessage ??
          'Could not sign in. Please try again.';
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
      appBar: AppBar(title: const Text('Login')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Welcome back',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppTextField(
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => _email = value,
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
            label: 'Login',
            isLoading: authState.isLoading,
            onPressed: _login,
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => context.push('/register'),
            child: const Text('Create a driver account'),
          ),
        ],
      ),
    );
  }
}

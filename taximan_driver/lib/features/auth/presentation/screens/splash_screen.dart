import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../onboarding/application/onboarding_flow.dart';
import '../../../onboarding/application/providers/driver_providers.dart';
import '../../application/providers/auth_state_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), _resolveInitialRoute);
  }

  Future<void> _resolveInitialRoute() async {
    if (!mounted) {
      return;
    }
    final authState = ref.read(authStateProvider);
    final driverId = authState.userId;
    if (!authState.isAuthenticated || driverId == null) {
      context.go('/onboarding');
      return;
    }

    try {
      final driver = await ref
          .read(driverRepositoryProvider)
          .fetchDriver(driverId);
      if (!mounted) {
        return;
      }
      if (driver == null) {
        await ref.read(authStateProvider.notifier).logout();
        if (mounted) {
          context.go('/login');
        }
        return;
      }
      context.go(nextDriverRoute(driver));
    } catch (_) {
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.directions_car,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Taximan Driver',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Drive, earn, and manage trips.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

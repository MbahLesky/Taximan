import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/models/driver.dart';
import '../../../../shared/utils/app_toast.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../matching/application/providers/driver_providers.dart';
import '../../application/providers/booking_state_provider.dart';

class DriverPreferenceScreen extends ConsumerStatefulWidget {
  const DriverPreferenceScreen({super.key});

  @override
  ConsumerState<DriverPreferenceScreen> createState() =>
      _DriverPreferenceScreenState();
}

class _DriverPreferenceScreenState
    extends ConsumerState<DriverPreferenceScreen> {
  String _query = '';

  void _selectDriver(BuildContext context, Driver driver) {
    ref
        .read(bookingStateProvider.notifier)
        .setPreferredDriver(driverId: driver.id, driverName: driver.fullName);
    context.push('/ride-summary');
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(availableDriversProvider, (previous, next) {
      if (next.hasError && previous?.hasError != true) {
        AppToast.warning(
          context,
          title: 'Driver list unavailable',
          description: 'You can still continue with automatic matching.',
        );
      }
    });

    final booking = ref.watch(bookingStateProvider).booking;
    final driversAsync = ref.watch(availableDriversProvider);
    final hasPreferredDriver = booking.preferredDriverId?.isNotEmpty == true;

    return Scaffold(
      appBar: AppBar(title: const Text('Driver preference')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.sensors,
                    color: AppColors.primaryDark,
                  ),
                  title: const Text('Nearby driver search'),
                  subtitle: driversAsync.when(
                    data: (drivers) => Text(
                      drivers.isEmpty
                          ? 'No nearby drivers found yet.'
                          : '${drivers.length} nearby driver(s) available.',
                    ),
                    loading: () =>
                        const Text('Searching around your pickup point.'),
                    error: (_, _) => const Text(
                      'Nearby search is unavailable right now.',
                    ),
                  ),
                  trailing: driversAsync.isLoading
                      ? const SizedBox.square(
                          dimension: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.radar),
                ),
                const Divider(height: 24),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.shuffle, color: AppColors.info),
                  title: const Text('Any available driver'),
                  subtitle: const Text(
                    'Skip driver selection and let Taximan match the ride.',
                  ),
                  trailing: hasPreferredDriver
                      ? null
                      : const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                        ),
                  onTap: () {
                    ref
                        .read(bookingStateProvider.notifier)
                        .clearPreferredDriver();
                    context.push('/ride-summary');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search drivers by name, car, or plate',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) => setState(() => _query = value),
          ),
          const SizedBox(height: AppSpacing.md),
          driversAsync.when(
            data: (drivers) {
              final filteredDrivers = _filterDrivers(drivers);
              if (filteredDrivers.isEmpty) {
                return const AppCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.person_search_outlined),
                    title: Text('No drivers found'),
                    subtitle: Text('You can continue without selecting one.'),
                  ),
                );
              }
              return Column(
                children: filteredDrivers.map((driver) {
                  final isSelected = booking.preferredDriverId == driver.id;
                  return AppCard(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryLight,
                        child: Text(
                          driver.fullName.isEmpty
                              ? 'D'
                              : driver.fullName.substring(0, 1),
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      title: Text(driver.fullName),
                      subtitle: Text(
                        '${driver.vehicle} - ${driver.plateNumber} - '
                        '${driver.arrivalEta}',
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                            )
                          : const Icon(Icons.arrow_forward),
                      onTap: () => _selectDriver(context, driver),
                    ),
                  );
                }).toList(),
              );
            },
            error: (_, __) => const AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.cloud_off, color: AppColors.warning),
                title: Text('Driver list unavailable'),
                subtitle: Text('You can still continue with auto-matching.'),
              ),
            ),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(AppSpacing.md),
        child: AppButton(
          label: hasPreferredDriver ? 'Continue to summary' : 'Skip to summary',
          icon: Icons.receipt_long_outlined,
          onPressed: () => context.push('/ride-summary'),
        ),
      ),
    );
  }

  List<Driver> _filterDrivers(List<Driver> drivers) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) {
      return drivers;
    }
    return drivers.where((driver) {
      return driver.fullName.toLowerCase().contains(query) ||
          driver.vehicle.toLowerCase().contains(query) ||
          driver.plateNumber.toLowerCase().contains(query);
    }).toList();
  }
}

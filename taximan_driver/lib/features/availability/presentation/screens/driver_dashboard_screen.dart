import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../earnings/application/providers/earnings_provider.dart';
import '../../../booking_management/application/providers/booking_provider.dart';
import '../../../onboarding/application/providers/driver_providers.dart';
import '../../application/providers/driver_state_provider.dart';
import '../../../trip/application/providers/trip_providers.dart';
import '../../../account/application/driver_payment_pin_provider.dart';
import '../../../account/presentation/widgets/driver_payment_pin_dialog.dart';
import '../../../../shared/models/app_location.dart';
import '../../../../shared/models/earnings.dart';
import '../../../../shared/models/trip.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';

class DriverDashboardScreen extends ConsumerWidget {
  const DriverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final earnings = ref.watch(earningsProvider);
    final currentDriver = ref.watch(currentDriverProvider).valueOrNull;
    final incomingRequests = ref.watch(availableBookingsStreamProvider).valueOrNull;
    final activeTrip = ref.watch(driverActiveTripProvider).valueOrNull;
    final earnings = ref.watch(earningsProvider).valueOrNull ??
        const Earnings(today: 0, week: 0, total: 0, completedTrips: 0);
    final online = currentDriver?.isAvailable ?? false;
    final driverName = currentDriver?.fullName.isNotEmpty == true
        ? currentDriver!.fullName
        : 'Driver';
    final verificationStatus = currentDriver?.verificationStatus ?? 'pending';
    final availabilityStatus = currentDriver?.availabilityStatus ?? 'offline';
    final canGoOnline = verificationStatus.toLowerCase() == 'approved';
    final pinState = ref.watch(driverPaymentPinProvider);

    return BottomNavShell(
      currentIndex: 0,
      title: 'Dashboard',
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning, ${driverName.split(' ').first}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Driver dashboard',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(
                  label: _availabilityLabel(availabilityStatus, online),
                  online: online,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        online
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: online
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          online
                              ? 'ONLINE - available for requests'
                              : 'OFFLINE - not receiving requests',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: online ? 'Go Offline' : 'Go Online',
                    icon: online ? Icons.power_settings_new : Icons.bolt,
                    variant: online
                        ? AppButtonVariant.secondary
                        : AppButtonVariant.primary,
                    onPressed: () async {
                      if (!online && !canGoOnline) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Approval is required before going online.',
                            ),
                          ),
                        );
                        return;
                      }
                      try {
                        await ref
                            .read(driverAvailabilityActionsProvider)
                            .toggleAvailability();
                      } catch (e) {
                        if (!context.mounted) {
                          return;
                        }
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.verified_user_outlined,
                  color: AppColors.warning,
                ),
                title: Text(_verificationLabel(verificationStatus)),
                subtitle: Text('Approval is required before live operations.'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.notifications_active_outlined,
                  color: AppColors.primaryDark,
                ),
                title: Text(
                  '${incomingRequests?.length ?? 0} incoming ride request${incomingRequests?.length == 1 ? '' : 's'}',
                ),
                subtitle: const Text('Review available bookings in real time.'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/incoming-request'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.lock_outline, color: AppColors.primaryDark),
                    title: Text(pinState.when(
                      data: (pin) => pin?.isNotEmpty == true
                          ? 'Confirm payment' : 'Set payment PIN',
                      loading: () => 'Payment PIN',
                      error: (_, __) => 'Payment PIN',
                    )),
                    subtitle: Text(pinState.when(
                      data: (pin) => pin?.isNotEmpty == true
                          ? 'Use your PIN to verify cash payment collection.'
                          : 'Create a payment PIN for safe cash collection.',
                      loading: () => 'Checking payment PIN status...',
                      error: (_, __) => 'Unable to retrieve PIN status.',
                    )),
                  ),
                  const Divider(height: 24),
                  AppButton(
                    label: pinState.when(
                      data: (pin) => pin?.isNotEmpty == true
                          ? 'Confirm cash payment'
                          : 'Set payment PIN',
                      loading: () => 'Loading...',
                      error: (_, __) => 'Set payment PIN',
                    ),
                    icon: Icons.payments_outlined,
                    variant: AppButtonVariant.primary,
                    isLoading: pinState.isLoading,
                    onPressed: pinState.isLoading
                        ? null
                        : () async {
                            final pin = pinState.valueOrNull;
                            if (pin?.isNotEmpty == true) {
                              await _showPaymentPinDialog(context, ref, pin!);
                            } else {
                              await showDriverPinSetupDialog(context, ref);
                            }
                          },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: 'Today',
                    value: earnings.todayFormatted,
                    icon: Icons.payments_outlined,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _MetricCard(
                    title: 'Trips',
                    value: '${earnings.completedTrips}',
                    icon: Icons.route,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            DriverDashboardMiniMap(activeTrip: activeTrip),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _QuickAction(
                  label: 'Schedule',
                  icon: Icons.schedule,
                  onTap: () => context.push('/availability-schedule'),
                ),
                _QuickAction(
                  label: 'Ride requests',
                  icon: Icons.notifications_active_outlined,
                  onTap: () => context.push('/incoming-request'),
                ),
                _QuickAction(
                  label: 'Documents',
                  icon: Icons.folder_copy_outlined,
                  onTap: () => context.push('/document-status'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showPaymentPinDialog(
  BuildContext context,
  WidgetRef ref,
  String expectedPin,
) async {
  final controller = TextEditingController();
  await showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Confirm payment PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your payment PIN to verify the cash collection.'),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
              decoration: const InputDecoration(
                hintText: 'Enter PIN',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final enteredPin = controller.text.trim();
              if (enteredPin.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter your payment PIN.')),
                );
                return;
              }
              if (enteredPin != expectedPin) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment PIN does not match.')),
                );
                return;
              }
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment confirmed successfully.')),
                );
              }
            },
            child: const Text('Verify'),
          ),
        ],
      );
    },
  );
}

String _availabilityLabel(String status, bool isOnline) {
  return switch (status.toLowerCase()) {
    'busy' => 'Busy',
    'online' => 'Available',
    _ => isOnline ? 'Available' : 'Offline',
  };
}

String _verificationLabel(String status) {
  return switch (status.toLowerCase()) {
    'approved' => 'Approved',
    'rejected' => 'Rejected',
    'suspended' => 'Suspended',
    'not_submitted' => 'Not submitted',
    _ => 'Pending verification',
  };
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.online});

  final String label;
  final bool online;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: online ? AppColors.primaryLight : AppColors.border,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: online ? AppColors.primaryDark : AppColors.textSecondary,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryDark),
          const SizedBox(height: AppSpacing.sm),
          Text(title, style: const TextStyle(color: AppColors.textSecondary)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class DriverDashboardMiniMap extends StatefulWidget {
  const DriverDashboardMiniMap({super.key, this.activeTrip});

  final Trip? activeTrip;

  @override
  State<DriverDashboardMiniMap> createState() => _DriverDashboardMiniMapState();
}

class _DriverDashboardMiniMapState extends State<DriverDashboardMiniMap> {
  final Completer<GoogleMapController> _mapController = Completer();
  late final Future<Position> _currentPositionFuture;

  @override
  void initState() {
    super.initState();
    _currentPositionFuture = _determinePosition();
  }

  Future<Position> _determinePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied.');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live map',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: AppSpacing.sm),
          FutureBuilder<Position>(
            future: _currentPositionFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return SizedBox(
                  height: 120,
                  child: Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                );
              }

              final current = LatLng(
                snapshot.data!.latitude,
                snapshot.data!.longitude,
              );
              final markers = <Marker>{
                Marker(
                  markerId: const MarkerId('current_location'),
                  position: current,
                  infoWindow: const InfoWindow(title: 'You'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure,
                  ),
                ),
              };
              final polylines = <Polyline>{};

              if (widget.activeTrip != null) {
                final pickup = _latLngFromLocation(widget.activeTrip!.pickup);
                final destination =
                    _latLngFromLocation(widget.activeTrip!.destinationLocation);
                if (pickup != null) {
                  markers.add(
                    Marker(
                      markerId: const MarkerId('pickup'),
                      position: pickup,
                      infoWindow: InfoWindow(
                        title: 'Pickup',
                        snippet: widget.activeTrip!.pickup.address,
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue,
                      ),
                    ),
                  );
                }
                if (destination != null) {
                  markers.add(
                    Marker(
                      markerId: const MarkerId('destination'),
                      position: destination,
                      infoWindow: InfoWindow(
                        title: 'Destination',
                        snippet: widget.activeTrip!.destinationLocation.address,
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                    ),
                  );
                }
                if (pickup != null && destination != null) {
                  polylines.add(
                    Polyline(
                      polylineId: const PolylineId('trip_route'),
                      points: [pickup, destination],
                      color: AppColors.primaryDark,
                      width: 4,
                    ),
                  );
                }
              }

              final initialCamera = CameraPosition(target: current, zoom: 13);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 220,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: GoogleMap(
                        initialCameraPosition: initialCamera,
                        markers: markers,
                        polylines: polylines,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        onMapCreated: (controller) {
                          if (!_mapController.isCompleted) {
                            _mapController.complete(controller);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    widget.activeTrip != null
                        ? 'Active trip: ${widget.activeTrip!.status}'
                        : 'No active trip. Tap to open the full screen map.',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerRight,
                    child: AppButton(
                      label: 'Open full screen',
                      icon: Icons.open_in_full,
                      variant: AppButtonVariant.secondary,
                      onPressed: () => context.push(
                        '/trip-map',
                        extra: widget.activeTrip,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  LatLng? _latLngFromLocation(AppLocation location) {
    if (location.latitude == null || location.longitude == null) {
      return null;
    }
    return LatLng(location.latitude!, location.longitude!);
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }
}

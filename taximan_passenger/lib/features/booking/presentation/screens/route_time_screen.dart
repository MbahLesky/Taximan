import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/data/bamenda_locations.dart';
import '../../../../shared/models/app_location.dart';
import '../../../../shared/utils/app_toast.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../application/providers/booking_state_provider.dart';

class RouteTimeScreen extends ConsumerWidget {
  const RouteTimeScreen({super.key});

  Future<void> _pickSchedule(
    BuildContext context,
    WidgetRef ref,
    DateTime? currentValue,
  ) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: currentValue ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    if (date == null || !context.mounted) {
      return;
    }
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentValue ?? now),
    );
    if (time == null) {
      return;
    }
    ref
        .read(bookingStateProvider.notifier)
        .setPickupTime(
          pickupTimeType: 'scheduled',
          scheduledPickupTime: DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          ),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(bookingStateProvider, (previous, next) {
      final message = next.errorMessage;
      if (message != null && message != previous?.errorMessage) {
        AppToast.error(
          context,
          title: 'Location unavailable',
          description: message,
        );
      }
    });

    final booking = ref.watch(bookingStateProvider).booking;
    final controller = ref.read(bookingStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Plan route')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _MapPreview(
            pickup: booking.pickup,
            destination: booking.destinationLocation,
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trip route',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                _LocationSelector(
                  label: 'Pickup',
                  icon: Icons.my_location,
                  selectedLocation: booking.pickup,
                  onSelected: controller.setPickupLocation,
                ),
                const Divider(height: 28),
                _LocationSelector(
                  label: 'Destination',
                  icon: Icons.location_on_outlined,
                  selectedLocation: booking.destinationLocation.address.isEmpty
                      ? null
                      : booking.destinationLocation,
                  onSelected: controller.setDestinationLocation,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pickup time',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'now',
                      icon: Icon(Icons.flash_on),
                      label: Text('Now'),
                    ),
                    ButtonSegment(
                      value: 'scheduled',
                      icon: Icon(Icons.schedule),
                      label: Text('Later'),
                    ),
                  ],
                  selected: {booking.pickupTimeType},
                  onSelectionChanged: (selection) {
                    final value = selection.first;
                    if (value == 'now') {
                      controller.setPickupTime(pickupTimeType: 'now');
                      return;
                    }
                    _pickSchedule(context, ref, booking.scheduledPickupTime);
                  },
                ),
                if (booking.pickupTimeType == 'scheduled') ...[
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton.icon(
                    onPressed: () => _pickSchedule(
                      context,
                      ref,
                      booking.scheduledPickupTime,
                    ),
                    icon: const Icon(Icons.event),
                    label: Text(
                      booking.scheduledPickupTime == null
                          ? 'Choose date and time'
                          : _formatDateTime(booking.scheduledPickupTime!),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Continue to ride details',
            icon: Icons.arrow_forward,
            onPressed: ref.watch(bookingStateProvider).canConfirmRide
                ? () => context.push('/ride-details')
                : null,
          ),
        ],
      ),
    );
  }
}

class _LocationSelector extends StatelessWidget {
  const _LocationSelector({
    required this.label,
    required this.icon,
    required this.selectedLocation,
    required this.onSelected,
  });

  final String label;
  final IconData icon;
  final AppLocation? selectedLocation;
  final ValueChanged<AppLocation> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: AppSpacing.xs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primaryDark),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                selectedLocation?.fullAddress ?? 'Select a Bamenda location',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Autocomplete<AppLocation>(
          displayStringForOption: (location) => location.fullAddress,
          optionsBuilder: (value) {
            final query = value.text.trim().toLowerCase();
            if (query.isEmpty) {
              return bamendaLocations;
            }
            return bamendaLocations.where((location) {
              return location.fullAddress.toLowerCase().contains(query) ||
                  (location.name?.toLowerCase().contains(query) ?? false);
            });
          },
          onSelected: onSelected,
          fieldViewBuilder:
              (context, textController, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: textController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Type to search Bamenda places',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      tooltip: 'Use current location',
                      icon: const Icon(Icons.gps_fixed),
                      onPressed: () => onSelected(defaultPassengerLocation),
                    ),
                  ),
                );
              },
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            ActionChip(
              avatar: const Icon(Icons.my_location, size: 18),
              label: const Text('Current location'),
              onPressed: () => onSelected(defaultPassengerLocation),
            ),
            ActionChip(
              avatar: const Icon(Icons.map_outlined, size: 18),
              label: const Text('Pin on map'),
              onPressed: () => _showMapPicker(context),
            ),
          ],
        ),
      ],
    );
  }

  void _showMapPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Text(
                'Pin location',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              const _MapPreview(),
              const SizedBox(height: AppSpacing.md),
              ...bamendaLocations.map(
                (location) => ListTile(
                  leading: const Icon(Icons.place_outlined),
                  title: Text(location.displayName),
                  subtitle: Text(location.fullAddress),
                  onTap: () {
                    onSelected(location.copyWith(source: 'map_pin'));
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MapPreview extends StatelessWidget {
  const _MapPreview({this.pickup, this.destination});

  final AppLocation? pickup;
  final AppLocation? destination;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _RoutePainter())),
          const Positioned(
            left: 42,
            top: 44,
            child: Icon(Icons.my_location, color: AppColors.info, size: 28),
          ),
          const Positioned(
            right: 44,
            bottom: 42,
            child: Icon(Icons.location_on, color: AppColors.error, size: 34),
          ),
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md,
            child: Text(
              destination?.address.isNotEmpty == true
                  ? '${pickup?.displayName ?? 'Pickup'} to '
                        '${destination!.displayName}'
                  : 'Bamenda service area',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    final routePaint = Paint()
      ..color = AppColors.primaryDark
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(20, size.height * .72),
      Offset(size.width - 24, 38),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * .16, 42),
      Offset(size.width * .86, size.height - 36),
      roadPaint,
    );
    canvas.drawLine(
      const Offset(58, 58),
      Offset(size.width - 60, size.height - 58),
      routePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

String _formatDateTime(DateTime value) {
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '${value.day}/${value.month}/${value.year} at $hour:$minute';
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../application/providers/driver_state_provider.dart';
import '../../data/driver_availability_repository.dart';
import '../../../onboarding/application/providers/driver_providers.dart';

class AvailabilityScheduleScreen extends ConsumerStatefulWidget {
  const AvailabilityScheduleScreen({super.key});

  @override
  ConsumerState<AvailabilityScheduleScreen> createState() =>
      _AvailabilityScheduleScreenState();
}

class _AvailabilityScheduleScreenState
    extends ConsumerState<AvailabilityScheduleScreen> {
  static const _days = [
    ('monday', 'Mon'),
    ('tuesday', 'Tue'),
    ('wednesday', 'Wed'),
    ('thursday', 'Thu'),
    ('friday', 'Fri'),
    ('saturday', 'Sat'),
    ('sunday', 'Sun'),
  ];

  final Set<String> _selectedDays = {
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
  };
  TimeOfDay _startTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 20, minute: 0);
  bool _isSaving = false;
  bool _hasLoadedSavedSchedule = false;

  Future<void> _pickTime({required bool start}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: start ? _startTime : _endTime,
    );
    if (picked == null) {
      return;
    }
    setState(() {
      if (start) {
        _startTime = picked;
      } else {
        _endTime = picked;
      }
    });
  }

  Future<void> _save() async {
    if (_selectedDays.isEmpty) {
      _showMessage('Choose at least one working day.');
      return;
    }

    final entries = _days
        .where((day) => _selectedDays.contains(day.$1))
        .map(
          (day) => AvailabilityScheduleEntry(
            day: day.$1,
            startTime: _formatStorageTime(_startTime),
            endTime: _formatStorageTime(_endTime),
          ),
        )
        .toList();

    setState(() => _isSaving = true);
    try {
      await ref.read(driverAvailabilityActionsProvider).saveSchedule(entries);
      _showMessage('Availability schedule saved.');
    } catch (e) {
      _showMessage(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _loadSavedSchedule(List<Map<String, String>> schedule) {
    if (_hasLoadedSavedSchedule || schedule.isEmpty) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _hasLoadedSavedSchedule) {
        return;
      }
      setState(() {
        _selectedDays
          ..clear()
          ..addAll(schedule.map((entry) => entry['day'] ?? ''));
        _selectedDays.remove('');

        final firstEntry = schedule.first;
        _startTime = _parseStorageTime(firstEntry['startTime']) ?? _startTime;
        _endTime = _parseStorageTime(firstEntry['endTime']) ?? _endTime;
        _hasLoadedSavedSchedule = true;
      });
    });
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final driver = ref.watch(currentDriverProvider).valueOrNull;
    _loadSavedSchedule(driver?.availabilitySchedule ?? const []);

    return Scaffold(
      appBar: AppBar(title: const Text('Availability schedule')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Working days',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final day in _days)
                      FilterChip(
                        label: Text(day.$2),
                        selected: _selectedDays.contains(day.$1),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedDays.add(day.$1);
                            } else {
                              _selectedDays.remove(day.$1);
                            }
                          });
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.play_arrow),
                  title: const Text('Start time'),
                  trailing: Text(_formatDisplayTime(context, _startTime)),
                  onTap: () => _pickTime(start: true),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.stop),
                  title: const Text('End time'),
                  trailing: Text(_formatDisplayTime(context, _endTime)),
                  onTap: () => _pickTime(start: false),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Save schedule',
            isLoading: _isSaving,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}

String _formatStorageTime(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String _formatDisplayTime(BuildContext context, TimeOfDay time) {
  return time.format(context);
}

TimeOfDay? _parseStorageTime(String? value) {
  if (value == null || !value.contains(':')) {
    return null;
  }
  final parts = value.split(':');
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) {
    return null;
  }
  return TimeOfDay(hour: hour, minute: minute);
}

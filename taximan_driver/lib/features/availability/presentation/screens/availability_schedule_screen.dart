import 'package:flutter/material.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

class AvailabilityScheduleScreen extends StatelessWidget {
  const AvailabilityScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Availability schedule')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Working days', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: const [
                    FilterChip(label: Text('Mon'), selected: true, onSelected: null),
                    FilterChip(label: Text('Tue'), selected: true, onSelected: null),
                    FilterChip(label: Text('Wed'), selected: true, onSelected: null),
                    FilterChip(label: Text('Thu'), selected: false, onSelected: null),
                    FilterChip(label: Text('Fri'), selected: true, onSelected: null),
                    FilterChip(label: Text('Sat'), selected: false, onSelected: null),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const AppCard(
            child: Column(
              children: [
                ListTile(leading: Icon(Icons.play_arrow), title: Text('Start time'), trailing: Text('7:00 AM')),
                ListTile(leading: Icon(Icons.stop), title: Text('End time'), trailing: Text('8:00 PM')),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'Save schedule', onPressed: () {}),
        ],
      ),
    );
  }
}
